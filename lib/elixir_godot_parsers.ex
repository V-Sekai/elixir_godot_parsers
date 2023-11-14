defmodule Color do
  defstruct r: 0, g: 0, b: 0, a: 0
end

defmodule Transform3D do
  defstruct cell0: 0,
            cell1: 0,
            cell2: 0,
            cell3: 0,
            cell4: 0,
            cell5: 0,
            cell6: 0,
            cell7: 0,
            cell8: 0,
            cell9: 0,
            cell10: 0,
            cell11: 0
end

defmodule Transform2D do
  defstruct cell0: 0, cell1: 0, cell2: 0, cell3: 0
end

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
  def tscn_parser(tscn_string) do
    tscn_string
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    cond do
      line =~ ~r/^\[gd_scene/ -> file_descriptor_parser(line)
      line =~ ~r/^\[node/ -> nodes_parser(line)
      line =~ ~r/^\[ext_resource/ -> external_resources_parser(line)
      line =~ ~r/^\[sub_resource/ -> internal_resources_parser(line)
      line =~ ~r/^\[connection/ -> connections_parser(line)
      true -> {:ok, line}
    end
  end

  @doc """
  Parses ESCN files.
  """
  def escn_parser(escn_string) do
    tscn_parser(escn_string)
  end

  @doc """
  Parses TRES files.
  """
  def tres_parser do
  end

  @doc """
  Serializes nodes.
  """
  def serialize_node(node) do
    "[node name=\"#{node.name}\" type=\"#{node.type}\"]"
  end

  @doc """
  Serializes file descriptors.
  """
  def serialize_file_descriptor(descriptor) do
    "[gd_scene load_steps=#{descriptor.load_steps} format=#{descriptor.format} uid=\"#{descriptor.uid}\"]"
  end

  @doc """
  Serializes external resources.
  """
  def serialize_external_resource(resource) do
    "[ext_resource path=\"#{resource.path}\" type=\"#{resource.type}\" id=#{resource.id}]"
  end

  @doc """
  Serializes internal resources.
  """
  def serialize_internal_resource(resource) do
    "[sub_resource type=\"#{resource.type}\" id=#{resource.id}]"
  end

  @doc """
  Serializes connections.
  """
  def serialize_connection(connection) do
    "[connection signal=\"#{connection.signal}\" from=\"#{connection.from}\" to=\"#{connection.to}\" method=\"#{connection.method}\"]"
  end

  @doc """
  Serializes color.
  """
  def serialize_color(color) do
    "Color(#{color.r}, #{color.g}, #{color.b}, #{color.a})"
  end

  @doc """
  Serializes transform.
  """
  def serialize_transform(transform) do
    "Transform3D(#{transform.cell0}, #{transform.cell1}, #{transform.cell2}, #{transform.cell3}, #{transform.cell4}, #{transform.cell5}, #{transform.cell6}, #{transform.cell7}, #{transform.cell8}, #{transform.cell9}, #{transform.cell10}, #{transform.cell11})"
  end

  @doc """
  Serializes TSCN files.
  """
  def serialize_tscn(tscn) do
    tscn
    |> Enum.map(&serialize_line/1)
    |> Enum.join("\n")
  end

  defp serialize_line(line) do
    cond do
      line =~ ~r/^\[gd_scene/ -> serialize_file_descriptor(line)
      line =~ ~r/^\[node/ -> serialize_node(line)
      line =~ ~r/^\[ext_resource/ -> serialize_external_resource(line)
      line =~ ~r/^\[sub_resource/ -> serialize_internal_resource(line)
      line =~ ~r/^\[connection/ -> serialize_connection(line)
      true -> line
    end
  end

  @doc """
  Serializes ESCN files.
  """
  def serialize_escn(escn) do
    serialize_tscn(escn)
  end

  @doc """
  Serializes TRES files.
  """
  def serialize_tres do
  end
end
