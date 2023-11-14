defmodule ElixirGodotParsersTest do
  use ExUnit.Case
  doctest ElixirGodotParsers

  alias ElixirGodotParsers, as: Parser

  @gd_scene "[gd_scene load_steps=4 format=3 uid=\"uid://cecaux1sm7mo0\"]"
  @node_descriptor "[node name=\"NodeName\" type=\"NodeType\"]"
  @sub_resource "[sub_resource type=\"YourType\" id=\"YourID\"]"
  @color "[color r=255 g=255 b=255 a=255]"
  @transform "[transform cell0=1 cell1=0 cell2=0]"

  test "parses gd_scene descriptor correctly" do
    assert {:ok, ["[gd_scene load_steps=", "4 format=3 uid=\"uid://cecaux1sm7mo0\"]"], "", %{},
            {1, 0},
            58} =
             Parser.file_descriptor_parser(@gd_scene)
  end

  test "parses node descriptor correctly" do
    assert {:ok, ["[node name=\"", "NodeName\" type=\"NodeType\"]"], "", %{}, {1, 0}, 38} =
             Parser.nodes_parser(@node_descriptor)
  end

  test "parses sub_resource descriptor correctly" do
    assert {:ok, ["[sub_resource type=\"", "YourType\" id=\"YourID\"]"], "", %{}, {1, 0}, 42} =
             Parser.sub_resource_parser(@sub_resource)
  end

  test "parses color correctly" do
    assert {:ok, ["[color r=", "255 g=255 b=255 a=255]"], "", %{}, {1, 0}, 31} =
             Parser.color_parser(@color)
  end

  test "parses transform correctly" do
    assert {:ok, ["[transform cell0=", "1 cell1=0 cell2=0]"], "", %{}, {1, 0}, 35} =
             Parser.transform_parser(@transform)
  end
end
