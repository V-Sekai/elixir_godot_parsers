defmodule ElixirGodotParsers.Bool do
  @type t :: %__MODULE__{value: integer()}
  defstruct value: 0
end

defmodule ElixirGodotParsers.Int do
  @type t :: %__MODULE__{value: integer()}
  defstruct value: 0
end

defmodule ElixirGodotParsers.Vector2 do
  @type t :: %__MODULE__{x: float(), y: float()}
  defstruct x: 0.0, y: 0.0
end

defmodule ElixirGodotParsers.Rect2 do
  @type t :: %__MODULE__{x: float(), y: float(), width: float(), height: float()}
  defstruct x: 0.0, y: 0.0, width: 0.0, height: 0.0
end

defmodule ElixirGodotParsers.Vector3 do
  @type t :: %__MODULE__{x: float(), y: float(), z: float()}
  defstruct x: 0.0, y: 0.0, z: 0.0
end

defmodule ElixirGodotParsers.Transform2D do
  @type t :: %__MODULE__{x: Vector2.t(), y: Vector2.t(), origin: Vector2.t()}
  defstruct x: %ElixirGodotParsers.Vector2{}, y: %ElixirGodotParsers.Vector2{}, origin: %ElixirGodotParsers.Vector2{}
end

defmodule ElixirGodotParsers.Plane do
  @type t :: %__MODULE__{normal: Vector3.t(), d: float()}
  defstruct normal: %ElixirGodotParsers.Vector3{}, d: 0.0
end

defmodule ElixirGodotParsers.Quaternion do
  @type t :: %__MODULE__{x: float(), y: float(), z: float(), w: float()}
  defstruct x: 0.0, y: 0.0, z: 0.0, w: 0.0
end

defmodule ElixirGodotParsers.AABB do
  @type t :: %__MODULE__{position: Vector3.t(), size: Vector3.t()}
  defstruct position: %ElixirGodotParsers.Vector3{}, size: %ElixirGodotParsers.Vector3{}
end

defmodule ElixirGodotParsers.Basis do
  @type t :: %__MODULE__{x: ElixirGodotParsers.Vector3.t(), y: ElixirGodotParsers.Vector3.t(), z: ElixirGodotParsers.Vector3.t()}
  defstruct x: %ElixirGodotParsers.Vector3{}, y: %ElixirGodotParsers.Vector3{}, z: %ElixirGodotParsers.Vector3{}
end

defmodule ElixirGodotParsers.Transform3D do
  @type t :: %__MODULE__{basis: ElixirGodotParsers.Basis.t(), origin: ElixirGodotParsers.Vector3.t()}
  defstruct basis: %ElixirGodotParsers.Basis{}, origin: %ElixirGodotParsers.Vector3{}
end

defmodule ElixirGodotParsers.Color do
  @type t :: %__MODULE__{r: float(), g: float(), b: float(), a: float()}
  defstruct r: 0.0, g: 0.0, b: 0.0, a: 0.0
end

defmodule ElixirGodotParsers.NodePath do
  @type t :: %__MODULE__{path: binary()}
  defstruct path: ""
end

defmodule RID do
  @type t :: %__MODULE__{id: integer()}
  defstruct id: 0
end

defmodule ElixirGodotParsers.Object do
  @type t :: %__MODULE__{class_name: binary(), properties: list()}
  defstruct class_name: "", properties: []
end

defmodule ElixirGodotParsers.Dictionary do
  @type t :: %__MODULE__{elements: list()}
  defstruct elements: []
end

defmodule ElixirGodotParsers.Array do
  @type t :: %__MODULE__{elements: list()}
  defstruct elements: []
end

defmodule ElixirGodotParsers.RawArray do
  @type t :: %__MODULE__{data: binary()}
  defstruct data: <<>>
end

defmodule ElixirGodotParsers.Int32Array do
  @type t :: %__MODULE__{data: list(integer())}
  defstruct data: []
end

defmodule ElixirGodotParsers.Int64Array do
  @type t :: %__MODULE__{data: list(integer())}
  defstruct data: []
end

defmodule ElixirGodotParsers.Float32Array do
  @type t :: %__MODULE__{data: list(float())}
  defstruct data: []
end

defmodule ElixirGodotParsers.Float64Array do
  @type t :: %__MODULE__{data: list(float())}
  defstruct data: []
end

defmodule ElixirGodotParsers.StringArray do
  @type t :: %__MODULE__{data: list(binary())}
  defstruct data: []
end

defmodule ElixirGodotParsers.Vector2Array do
  @type t :: %__MODULE__{data: list(Vector2.t())}
  defstruct data: []
end

defmodule ElixirGodotParsers.Vector3Array do
  @type t :: %__MODULE__{data: list(Vector3.t())}
  defstruct data: []
end

defmodule ElixirGodotParsers.ColorArray do
  @type t :: %__MODULE__{data: list(Color.t())}
  defstruct data: []
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
    "Transform3D(#{transform.cell_0}, #{transform.cell_1}, #{transform.cell_2}, #{transform.cell_3}, #{transform.cell_4}, #{transform.cell_5}, #{transform.cell_6}, #{transform.cell_7}, #{transform.cell_8}, #{transform.cell_9}, #{transform.cell_10}, #{transform.cell_11})"
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
end
