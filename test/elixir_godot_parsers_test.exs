defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  alias ElixirGodot, as: Parser

  @gd_scene "[gd_scene load_steps=4 format=3 uid=\"uid://cecaux1sm7mo0\"]"
  @node_descriptor "[node name=\"NodeName\" type=\"NodeType\"]"
  @sub_resource "[sub_resource type=\"YourType\" id=\"YourID\"]"
  @color "Color(255, 255, 255, 255)"
  @transform "Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"

  test "tscn_parser/1" do
    assert [ok: "[gd_scene load_steps=4 format=3 uid=\"uid://cecaux1sm7mo0\"]"] = Parser.tscn_parser(@gd_scene)
    assert [ok: "[node name=\"NodeName\" type=\"NodeType\"]"] = Parser.tscn_parser(@node_descriptor)
    assert [ok: "[sub_resource type=\"YourType\" id=\"YourID\"]"] = Parser.tscn_parser(@sub_resource)
    assert [ok: "Color(255, 255, 255, 255)"] = Parser.tscn_parser(@color)
    assert [ok: "Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"] = Parser.tscn_parser(@transform)
  end
end
