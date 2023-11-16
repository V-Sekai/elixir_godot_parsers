defmodule ElixirGodotParsersTest do
  use ExUnit.Case

  describe "tscn/1" do
    test "returns an error when parsing fails" do
      assert {:error, _, _, _, _, _} = ElixirGodotParsers.tscn("")
    end

    test "parsing is successful" do
      assert {:ok, [{:file_descriptor, [{:gd_scene, [~c"gd_scene"]}, {:load_steps, [5]}, {:format, [3]}, {:uid, ~c"uid://b2agmmarkv5l3"}]}, "]"], "", %{}, {1, 0}, 58} = ElixirGodotParsers.tscn("[gd_scene load_steps=5 format=3 uid=\"uid://b2agmmarkv5l3\"]")
    end
  end
end
