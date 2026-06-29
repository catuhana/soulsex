defmodule Soulseek.SharedFile do
  @moduledoc """
  A file entry shared by peer file listings and search results (SharedFileList,
  FileSearch, FolderContents responses): a filename, size, extension, and a list
  of attributes.

  The leading `1` "code" byte each entry carries on the wire is written by
  `encode/1` and asserted by `take/1`, so it is not stored on the struct.
  """

  alias Soulseek.{FileAttributeType, Wire}

  defmodule Attribute do
    @moduledoc "A file attribute: a `Soulseek.FileAttributeType` and its value."

    @enforce_keys [:type, :value]
    defstruct [:type, :value]

    @type t :: %__MODULE__{type: FileAttributeType.t(), value: non_neg_integer()}
  end

  @enforce_keys [:filename, :size, :extension, :attributes]
  defstruct [:filename, :size, :extension, :attributes]

  @type t :: %__MODULE__{
          filename: String.t(),
          size: non_neg_integer(),
          extension: String.t(),
          attributes: [Attribute.t()]
        }

  @spec encode(t()) :: iodata()
  def encode(%__MODULE__{} = file),
    do: [
      Wire.uint8(1),
      Wire.string(file.filename),
      Wire.uint64(file.size),
      Wire.string(file.extension),
      Wire.array(file.attributes, &encode_attribute/1)
    ]

  defp encode_attribute(%Attribute{type: type, value: value}),
    do: [type |> FileAttributeType.to_wire() |> Wire.uint32(), Wire.uint32(value)]

  @spec take(binary()) :: {t(), binary()}
  def take(<<1, rest::binary>>) do
    {filename, rest} = Wire.take_string(rest)
    {size, rest} = Wire.take_uint64(rest)
    {extension, rest} = Wire.take_string(rest)
    {attributes, rest} = Wire.take_array(rest, &take_attribute/1)

    {%__MODULE__{filename: filename, size: size, extension: extension, attributes: attributes},
     rest}
  end

  defp take_attribute(binary) do
    {code, rest} = Wire.take_uint32(binary)
    {value, rest} = Wire.take_uint32(rest)

    {%Attribute{type: FileAttributeType.from_wire(code), value: value}, rest}
  end
end
