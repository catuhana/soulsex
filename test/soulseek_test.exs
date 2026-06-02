defmodule SoulseekTest do
  use ExUnit.Case

  doctest Soulseek

  test "greets the world" do
    assert Soulseek.greet("World") == "Hello, World!"
  end
end
