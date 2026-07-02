defmodule Soulseek.Server.Recommendations do
  @moduledoc """
  The Recommendations message (server code 54).

  The client sends an empty `Request`; the server replies with a `Response`
  listing personal recommendations and unrecommendations, each with a score.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "An empty request for recommendations, sent by the client to the server."

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule Recommendation do
    @moduledoc "A recommendation and its score (negative for unrecommendations)."

    @enforce_keys [:item, :score]
    defstruct [:item, :score]

    @type t :: %__MODULE__{item: String.t(), score: integer()}
  end

  defmodule Response do
    @moduledoc "Personal recommendations, sent by the server to the client."

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

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Recommendations.Request do
  def encode(%Soulseek.Server.Recommendations.Request{}), do: []
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Recommendations.Response do
  alias Soulseek.Server.Recommendations.Recommendation
  alias Soulseek.Wire

  def encode(%Soulseek.Server.Recommendations.Response{
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
