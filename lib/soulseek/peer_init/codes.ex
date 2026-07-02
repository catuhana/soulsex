defmodule Soulseek.PeerInit.Codes do
  @moduledoc "Registry of peer init message codes mapped to their message modules."

  @codes %{
    0 => Soulseek.PeerInit.PierceFirewall,
    1 => Soulseek.PeerInit.PeerInit
  }

  @modules Map.new(@codes, fn {code, module} -> {module, code} end)

  @spec module(non_neg_integer()) :: module() | nil
  def module(code), do: Map.get(@codes, code)

  @spec code(module()) :: non_neg_integer() | nil
  def code(module), do: Map.get(@modules, module)

  @spec modules() :: [module()]
  def modules(), do: Map.keys(@modules)
end
