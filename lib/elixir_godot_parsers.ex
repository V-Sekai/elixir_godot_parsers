defmodule ElixirGodotParsers do
  import NimbleParsec

  @doc """
  Parses nodes in Godot files.
  """
  defparsec(
    :nodes_parser,
    string("[node name=\"")
    |> concat(repeat(choice([ascii_string([?\s..?~], min: 1), utf8_char([])])))
    |> optional(string("\" type=\""))
    |> concat(repeat(choice([ascii_string([?\s..?~], min: 1), utf8_char([])])))
    |> optional(string("\"]")),
    debug: false
  )

  @doc """
  Parses file descriptors in Godot files.
  """
  defparsec(
    :file_descriptor_parser,
    string("[gd_scene load_steps=")
    |> repeat(utf8_string([], min: 1))
    |> optional(string(" format="))
    |> repeat(utf8_string([], min: 1))
    |> optional(string(" uid=\""))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\"]")),
    debug: false
  )

  @doc """
  Parses external resources in Godot files.
  """
  defparsec(
    :external_resources_parser,
    string("[ext_resource path=\"")
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" type=\""))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" id="))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("]")),
    debug: false
  )

  @doc """
  Parses internal resources in Godot files.
  """
  defparsec(
    :internal_resources_parser,
    string("[sub_resource type=\"")
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" id="))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("]")),
    debug: false
  )

  @doc """
  Parses connections in Godot files.
  """
  defparsec(
    :connections_parser,
    string("[connection signal=\"")
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" from=\""))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" to=\""))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" method=\""))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\"]")),
    debug: false
  )

  @doc """
  Parses sub_resource descriptor in Godot files.
  """
  defparsec(
    :sub_resource_parser,
    string("[sub_resource type=\"")
    |> repeat(utf8_string([], min: 1))
    |> optional(string("\" id="))
    |> repeat(utf8_string([], min: 1))
    |> optional(string("]")),
    debug: false
  )

  @doc """
  Parses color in Godot files.
  """
  defparsec(
    :color_parser,
    choice([
      string("Color(")
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(")")),
      string("[color r=")
      |> repeat(utf8_string([], min: 1))
      |> optional(string(" g="))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(" b="))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(" a="))
      |> repeat(utf8_string([], min: 1))
      |> optional(string("]"))
    ]),
    debug: false
  )

  @doc """
  Parses transform in Godot files.
  """
  defparsec(
    :transform_parser,
    choice([
      string("Transform3D(")
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(", "))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(")")),
      string("[transform cell0=")
      |> repeat(utf8_string([], min: 1))
      |> optional(string(" cell1="))
      |> repeat(utf8_string([], min: 1))
      |> optional(string(" cell2="))
      |> repeat(utf8_string([], min: 1))
      |> optional(string("]"))
    ]),
    debug: false
  )

  @doc """
  Parses TSCN files.
  """
  def tscn_parser do
  end

  @doc """
  Parses ESCN files.
  """
  def escn_parser do
    # ESCN parsing may be identical to TSCN, with additional handling for exported properties
  end

  @doc """
  Parses TRES files.
  """
  def tres_parser do
  end
end
