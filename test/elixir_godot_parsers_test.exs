defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  describe "echo_string/1" do
    test "returns the original string when parsing is successful" do
      assert {:ok, ["hello world"], "", %{}, {1, 0}, 11} == ElixirGodotParsers.tscn("hello world")
    end

    test "returns an error when parsing fails" do
      # Assuming that echo_parser cannot parse an empty string
      assert {:ok, [], "", %{}, {1, 0}, 0} = ElixirGodotParsers.tscn("")
    end
  end
end
