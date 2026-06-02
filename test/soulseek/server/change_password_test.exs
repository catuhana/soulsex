defmodule Soulseek.Server.ChangePasswordTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ChangePassword
  alias Soulseek.Wire

  test "encodes the password" do
    assert IO.iodata_to_binary(ChangePassword.encode(%ChangePassword{password: "hunter2"})) ==
             IO.iodata_to_binary(Wire.string("hunter2"))
  end

  test "decodes the password" do
    assert ChangePassword.decode(IO.iodata_to_binary(Wire.string("hunter2"))) ==
             %ChangePassword{password: "hunter2"}
  end

  test "round trips" do
    msg = %ChangePassword{password: "s3cret"}

    assert msg |> ChangePassword.encode() |> IO.iodata_to_binary() |> ChangePassword.decode() ==
             msg
  end
end
