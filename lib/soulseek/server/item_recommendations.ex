defmodule Soulseek.Server.ItemRecommendations do
  @moduledoc """
  The ItemRecommendations message (server code 111).

  The client sends a `Request` with an item; the server replies with a
  `Response` listing recommendations related to that item, each with a score.

  The protocol document labels the score `uint32` but notes it can be negative,
  so it is treated as a signed `int32` here.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A request for recommendations related to an item, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:item]
    defstruct [:item]

    @type t :: %__MODULE__{item: String.t()}

    @impl true
    def decode(binary) do
      {item, <<>>} = Wire.take_string(binary)

      %__MODULE__{item: item}
    end
  end

  defmodule Recommendation do
    @moduledoc "A recommendation related to an item, and its score."

    @enforce_keys [:item, :score]
    defstruct [:item, :score]

    @type t :: %__MODULE__{item: String.t(), score: integer()}
  end

  defmodule Response do
    @moduledoc "Recommendations related to an item, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:item, :recommendations]
    defstruct [:item, :recommendations]

    @type t :: %__MODULE__{item: String.t(), recommendations: [Recommendation.t()]}

    @impl true
    def decode(binary) do
      {item, rest} = Wire.take_string(binary)
      {recommendations, <<>>} = Wire.take_array(rest, &take_recommendation/1)

      %__MODULE__{item: item, recommendations: recommendations}
    end

    defp take_recommendation(binary) do
      {item, rest} = Wire.take_string(binary)
      {score, rest} = Wire.take_int32(rest)

      {%Recommendation{item: item, score: score}, rest}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ItemRecommendations.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ItemRecommendations.Request{item: item}), do: Wire.string(item)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ItemRecommendations.Response do
  alias Soulseek.Server.ItemRecommendations.Recommendation
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ItemRecommendations.Response{
        item: item,
        recommendations: recommendations
      }),
      do: [Wire.string(item), Wire.array(recommendations, &encode_recommendation/1)]

  defp encode_recommendation(%Recommendation{item: item, score: score}),
    do: [Wire.string(item), Wire.int32(score)]
end
