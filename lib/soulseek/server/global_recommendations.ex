defmodule Soulseek.Server.GlobalRecommendations do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule Recommendation do
    @moduledoc false

    @enforce_keys [:item, :score]
    defstruct [:item, :score]

    @type t :: %__MODULE__{item: String.t(), score: integer()}
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:recommendations, :unrecommendations]
    defstruct [:recommendations, :unrecommendations]

    @type t :: %__MODULE__{
            recommendations: [Recommendation.t()],
            unrecommendations: [Recommendation.t()]
          }

    @impl true
    def decode(binary) do
      {recommendations, rest} = Wire.take_array(binary, &take_recommendation/1)
      {unrecommendations, <<>>} = Wire.take_array(rest, &take_recommendation/1)

      %__MODULE__{recommendations: recommendations, unrecommendations: unrecommendations}
    end

    defp take_recommendation(binary) do
      {item, rest} = Wire.take_string(binary)
      {score, rest} = Wire.take_int32(rest)

      {%Recommendation{item: item, score: score}, rest}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GlobalRecommendations.Request do
  def encode(%Soulseek.Server.GlobalRecommendations.Request{}), do: []
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GlobalRecommendations.Response do
  alias Soulseek.Server.GlobalRecommendations.Recommendation
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GlobalRecommendations.Response{
        recommendations: recommendations,
        unrecommendations: unrecommendations
      }),
      do: [
        Wire.array(recommendations, &encode_recommendation/1),
        Wire.array(unrecommendations, &encode_recommendation/1)
      ]

  defp encode_recommendation(%Recommendation{item: item, score: score}),
    do: [Wire.string(item), Wire.int32(score)]
end
