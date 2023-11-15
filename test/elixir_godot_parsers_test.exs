defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  alias ElixirGodot, as: Parser

  defmodule ElixirGodotParsersTest do
    use ExUnit.Case

    alias ElixirGodot, as: Parser

    @gd_resource """
    [gd_scene load_steps=4 format=3 uid="uid://cecaux1sm7mo0"]

    [sub_resource type="SphereShape3D" id="SphereShape3D_tj6p1"]

    [sub_resource type="SphereMesh" id="SphereMesh_4w3ye"]

    [sub_resource type="StandardMaterial3D" id="StandardMaterial3D_k54se"]
    albedo_color = Color(1, 0.639216, 0.309804, 1)

    [node name="Ball" type="RigidBody3D"]

    [node name="CollisionShape3D" type="CollisionShape3D" parent="."]
    shape = SubResource("SphereShape3D_tj6p1")

    [node name="MeshInstance3D" type="MeshInstance3D" parent="."]
    mesh = SubResource("SphereMesh_4w3ye")
    surface_material_override/0 = SubResource("StandardMaterial3D_k54se")

    [node name="OmniLight3D" type="OmniLight3D" parent="."]
    light_color = Color(1, 0.698039, 0.321569, 1)
    omni_range = 10.0

    [node name="Camera3D" type="Camera3D" parent="."]
    transform = Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)
    """

    test "tscn_parser/1" do
      assert [
               ok: "[gd_scene load_steps=4 format=3 uid=\"uid://cecaux1sm7mo0\"]",
               ok: "",
               ok: "[sub_resource type=\"SphereShape3D\" id=\"SphereShape3D_tj6p1\"]",
               ok: "",
               ok: "[sub_resource type=\"SphereMesh\" id=\"SphereMesh_4w3ye\"]",
               ok: "",
               ok: "[sub_resource type=\"StandardMaterial3D\" id=\"StandardMaterial3D_k54se\"]",
               ok: "albedo_color = Color(1, 0.639216, 0.309804, 1)",
               ok: "",
               ok: "[node name=\"Ball\" type=\"RigidBody3D\"]",
               ok: "",
               ok: "[node name=\"CollisionShape3D\" type=\"CollisionShape3D\" parent=\".\"]",
               ok: "shape = SubResource(\"SphereShape3D_tj6p1\")",
               ok: "",
               ok: "[node name=\"MeshInstance3D\" type=\"MeshInstance3D\" parent=\".\"]",
               ok: "mesh = SubResource(\"SphereMesh_4w3ye\")",
               ok: "surface_material_override/0 = SubResource(\"StandardMaterial3D_k54se\")",
               ok: "",
               ok: "[node name=\"OmniLight3D\" type=\"OmniLight3D\" parent=\".\"]",
               ok: "light_color = Color(1, 0.698039, 0.321569, 1)",
               ok: "omni_range = 10.0",
               ok: "",
               ok: "[node name=\"Camera3D\" type=\"Camera3D\" parent=\".\"]",
               ok:
                 "transform = Transform3D(1, 0, 0, 0, 0.939693, 0.34202, 0, -0.34202, 0.939693, 0, 1, 3)",
               ok: ""
             ] = Parser.tscn_parser(@gd_resource)
    end
  end
end
