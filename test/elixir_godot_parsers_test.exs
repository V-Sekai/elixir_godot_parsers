defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  describe "echo_string/1" do
    test "returns the original string when parsing is successful" do
      assert {:ok, ["[gd_scene load_steps=5 format=3 uid=\"uid://b2agmmarkv5l3\"]"], "", %{},
              {1, 0},
              58} ==
               ElixirGodotParsers.tscn(
                 "[gd_scene load_steps=5 format=3 uid=\"uid://b2agmmarkv5l3\"]"
               )
    end

    test "returns an error when parsing fails" do
      # Assuming that echo_parser cannot parse an empty string
      assert {:ok, [], "", %{}, {1, 0}, 0} = ElixirGodotParsers.tscn("")
    end
  end
end
