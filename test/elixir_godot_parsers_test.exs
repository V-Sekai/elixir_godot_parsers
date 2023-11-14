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

  @omni_light "[node name=\"OmniLight3D\" type=\"OmniLight3D\" parent=\".\"] light_color = Color(1, 0.698039, 0.321569, 1) omni_range = 10.0"
  @camera "[node name=\"Camera3D\" type=\"Camera3D\" parent=\".\"] transform = Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"

  test "parses OmniLight3D node correctly" do
    assert {:ok,
            [
              "[node name=\"",
              "OmniLight3D\" type=\"OmniLight3D\" parent=\".\"] light_color = Color(1, 0.698039, 0.321569, 1) omni_range = 10.0"
            ], "", %{}, {1, 0},
            119} =
             Parser.nodes_parser(@omni_light)
  end

  test "parses Camera3D node correctly" do
    assert {:ok,
            [
              "[node name=\"",
              "Camera3D\" type=\"Camera3D\" parent=\".\"] transform = Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"
            ], "", %{}, {1, 0},
            136} =
             Parser.nodes_parser(@camera)
  end

  @omni_light_color "Color(1, 0.698039, 0.321569, 1)"
  @camera_transform "Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"

  test "parses OmniLight3D color correctly" do
    assert {:ok, ["Color(", "1, 0.698039, 0.321569, 1)"], "", %{}, {1, 0}, 31} =
             Parser.color_parser(@omni_light_color)
  end

  test "parses Camera3D transform correctly" do
    assert {:ok,
            ["Transform3D(", "1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)"],
            "", %{}, {1, 0},
            74} =
             Parser.transform_parser(@camera_transform)
  end

  @connection "[connection signal=\"timeout\" from=\"Timer\" to=\".\" method=\"_on_Timer_timeout\"]"
  @external_resource "[ext_resource path=\"res://icon.png\" type=\"Texture\" id=1]"

  test "parses external resource descriptor correctly" do
    # Convert the list to a binary
    binary_external_resource = Enum.join(@external_resource)

    expected_result = {:ok, ["[ext_resource path=\"", "res://icon.png\" type=\"Texture\" id=1]"], "", %{}, {1, 0}, 56}

    assert expected_result == ElixirGodotParsers.external_resources_parser(binary_external_resource, [])
  end


  test "parses connection descriptor correctly" do
    assert {:ok,
            [
              "[connection signal=\"",
              "timeout\" from=\"Timer\" to=\".\" method=\"_on_Timer_timeout\"]"
            ], "", %{}, {1, 0},
            76} =
             Parser.connections_parser(@connection)
  end

  @gd_scene_with_nodes "[gd_scene load_steps=2 format=2]\n[node name=\"Node\" type=\"Node\"]"
  @gd_scene_with_resources "[gd_scene load_steps=2 format=2]\n[ext_resource path=\"res://icon.png\" type=\"Texture\" id=1]"

  test "parses gd_scene with nodes correctly" do
    assert [
             {:ok, ["[gd_scene load_steps=", "2 format=2]"], "", %{}, {1, 0}, 32},
             {:ok, ["[node name=\"", "Node\" type=\"Node\"]"], "", %{}, {1, 0}, 30}
           ] =
             Parser.tscn_parser(@gd_scene_with_nodes)
  end

  test "parses gd_scene with resources correctly" do
    assert [
             {:ok, ["[gd_scene load_steps=", "2 format=2]"], "", %{}, {1, 0}, 32},
             {:ok, ["[ext_resource path=\"", "res://icon.png\" type=\"Texture\" id=1]"], "", %{},
              {1, 0}, 56}
           ] =
             Parser.tscn_parser(@gd_scene_with_resources)
  end
end
