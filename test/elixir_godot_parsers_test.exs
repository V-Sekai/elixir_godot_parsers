defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  describe "tscn/1" do
    test "returns an error when parsing fails" do
      assert {:error, _, _, _, _, _} = ElixirGodotParsers.tscn("")
    end

    test "parsing is successful" do
      assert  {:ok, [document: [file_descriptor: [{:gd_scene, [~c"gd_scene"]}, {:load_steps, [5]}, {:format, [3]}, {:uid, ~c"uid://b2agmmarkv5l3"}]]], "", %{}, {1, 0}, 58} = ElixirGodotParsers.tscn("[gd_scene load_steps=5 format=3 uid=\"uid://b2agmmarkv5l3\"]")
    end

    test "tscn parser correctly parses gd_scene and sub_resource" do
      assert  {
        :ok,
        [document: [file_descriptor: [gd_scene: [~c"gd_scene"], load_steps: [5], format: [3], uid: ~c"uid://b2agmmarkv5l3"]]],
        "[sub_resource type=\"StandardMaterial3D\" id=\"StandardMaterial3D_jln1w\"]\r\nresource_name = \"Material\"\r\ncull_mode = 2\r\nvertex_color_use_as_albedo = true\r\n",
        %{},
        {3, 62},
        62
      } = ElixirGodotParsers.tscn(
        """
        [gd_scene load_steps=5 format=3 uid="uid://b2agmmarkv5l3"]

        [sub_resource type="StandardMaterial3D" id="StandardMaterial3D_jln1w"]
        resource_name = "Material"
        cull_mode = 2
        vertex_color_use_as_albedo = true
        """)
    end

  end
end
