defmodule ElixirGodotSerializersTest do
  use ExUnit.Case
  doctest ElixirGodotParsers

  alias ElixirGodotParsers, as: Serializer

  @node %{name: "Node1", type: "Type1"}
  @descriptor %{load_steps: 2, format: 3, uid: "1234"}
  @resource %{path: "/path/to/resource", type: "ResourceType", id: 1}
  @connection %{signal: "Signal1", from: "From1", to: "To1", method: "Method1"}
  @color %{r: 255, g: 255, b: 255, a: 255}
  @transform %{
    cell_0: 0,
    cell_1: 1,
    cell_2: 2,
    cell_3: 3,
    cell_4: 4,
    cell_5: 5,
    cell_6: 6,
    cell_7: 7,
    cell_8: 8,
    cell_9: 9,
    cell_10: 10,
    cell_11: 11
  }

  test "serialize_node/1" do
    assert Serializer.serialize_node(@node) == "[node name=\"Node1\" type=\"Type1\"]"
  end

  test "serialize_file_descriptor/1" do
    assert Serializer.serialize_file_descriptor(@descriptor) ==
             "[gd_scene load_steps=2 format=3 uid=\"1234\"]"
  end

  test "serialize_external_resource/1" do
    assert Serializer.serialize_external_resource(@resource) ==
             "[ext_resource path=\"/path/to/resource\" type=\"ResourceType\" id=1]"
  end

  test "serialize_internal_resource/1" do
    assert Serializer.serialize_internal_resource(@resource) ==
             "[sub_resource type=\"ResourceType\" id=1]"
  end

  test "serialize_connection/1" do
    assert Serializer.serialize_connection(@connection) ==
             "[connection signal=\"Signal1\" from=\"From1\" to=\"To1\" method=\"Method1\"]"
  end

  test "serialize_color/1" do
    assert Serializer.serialize_color(@color) == "Color(255, 255, 255, 255)"
  end

  test "serialize_transform/1" do
    assert Serializer.serialize_transform(@transform) ==
             "Transform3D(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)"
  end

  test "serialize_tscn/1" do
  end
end
