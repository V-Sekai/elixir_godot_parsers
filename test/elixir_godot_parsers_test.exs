defmodule ElixirGodotParsersTest do
  use ExUnit.Case
  doctest ElixirGodotParsers

  alias ElixirGodotParsers, as: Parser

  @gd_scene "[gd_scene load_steps=4 format=3 uid=\"uid://cecaux1sm7mo0\"]"

  @node_descriptor "[node name=\"NodeName\" type=\"NodeType\"]"

  test "parses gd_scene descriptor correctly" do
    assert {:ok, ["[gd_scene load_steps=", "4 format=3 uid=\"uid://cecaux1sm7mo0\"]"], "", %{},
            {1, 0},
            58} =
             Parser.file_descriptor(@gd_scene)
  end

  test "parses node descriptor correctly" do
    assert {:ok, ["[node name=\"", "NodeName\" type=\"NodeType\"]"], "", %{}, {1, 0}, 38} =
             Parser.nodes_parser(@node_descriptor)
  end
end
