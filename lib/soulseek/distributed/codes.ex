defmodule Soulseek.Distributed.Codes do
  @moduledoc false

  @codes %{
    3 => Soulseek.Distributed.Search,
    4 => Soulseek.Distributed.BranchLevel,
    5 => Soulseek.Distributed.BranchRoot
  }

  @modules Map.new(@codes, fn {code, module} -> {module, code} end)

  @spec module(non_neg_integer()) :: module() | nil
  def module(code), do: Map.get(@codes, code)

  @spec code(module()) :: non_neg_integer() | nil
  def code(module), do: Map.get(@modules, module)

  @spec modules :: [module()]
  def modules, do: Map.keys(@modules)
end
