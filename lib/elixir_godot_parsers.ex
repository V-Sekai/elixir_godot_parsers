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
  defstruct x: %ElixirGodotParsers.Vector2{},
            y: %ElixirGodotParsers.Vector2{},
            origin: %ElixirGodotParsers.Vector2{}
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
  @type t :: %__MODULE__{
          x: ElixirGodotParsers.Vector3.t(),
          y: ElixirGodotParsers.Vector3.t(),
          z: ElixirGodotParsers.Vector3.t()
        }
  defstruct x: %ElixirGodotParsers.Vector3{},
            y: %ElixirGodotParsers.Vector3{},
            z: %ElixirGodotParsers.Vector3{}
end

defmodule ElixirGodotParsers.Transform3D do
  @type t :: %__MODULE__{
          basis: ElixirGodotParsers.Basis.t(),
          origin: ElixirGodotParsers.Vector3.t()
        }
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
  use AbnfParsec,
    abnf: """
    ip = first dot second dot third dot fourth
    dot = "."
    dec-octet =
      "25" %x30-35      /   ; 250-255
      "2" %x30-34 DIGIT /   ; 200-249
      "1" 2DIGIT        /   ; 100-199
      %x31-39 DIGIT     /   ; 10-99
      DIGIT                 ; 0-9
    first = dec-octet
    second = dec-octet
    third = dec-octet
    fourth = dec-octet
    """,
    unbox: ["dec-octet"],
    ignore: ["dot"],
    parse: :ip,
    parse: :nodes
end

defmodule ElixirGodot do
  def tscn_parser(tscn_string) do
    tscn_string
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    case line do
      ~r/^\[node/ -> ElixirGodotParsers.parse(:nodes, line)
      _ -> {:ok, line}
    end
  end
end

    # """
    #   file-descriptor = "[gd_scene load_steps=" load-steps " format=" format " uid=\"" uid "\"]"
    #   load-steps = 1*DIGIT ; one or more digits
    #   format = 1*DIGIT ; one or more digits
    #   uid = 1*HEXDIG ; one or more hexadecimal digits

    #   external-resource = "[ext_resource path=\"" path "\" type=\"" resource-type "\" id=" id "]"
    #   path = *ALPHA "/" *ALPHA ; a simple path rule, you might need to adjust this
    #   resource-type = 1*ALPHA ; one or more alphabetic characters
    #   id = 1*DIGIT ; one or more digits

    #   external-resource = "[ext_resource path=\"" path "\" type=\"" resource-type "\" id=" id "]"
    #   path = *ALPHA "/" *ALPHA ; a simple path rule, you might need to adjust this
    #   resource-type = 1*ALPHA ; one or more alphabetic characters
    #   id = 1*DIGIT ; one or more digits

    #   internal-resource = "[sub_resource type=\"" resource-type "\" id=" id "]"

    #   connection = "[connection signal=\"" signal "\" from=\"" from "\" to=\"" to "\" method=\"" method "\"]"
    #   signal = *CHAR
    #   from = *CHAR
    #   to = *CHAR
    #   method = *CHAR

    #   color = "Color(" r ", " g ", " b ", " a ")"
    #   r = *DIGIT "." *DIGIT
    #   g = *DIGIT "." *DIGIT
    #   b = *DIGIT "." *DIGIT
    #   a = *DIGIT "." *DIGIT

    #   transform = "Transform3D(" cell-0 ", " cell-1 ", " cell-2 ", " cell-3 ", " cell-4 ", " cell-5 ", " cell-6 ", " cell-7 ", " cell-8 ", " cell-9 ", " cell-10 ", " cell-11 ")"
    #   cell-0 = *DIGIT "." *DIGIT
    #   cell-1 = *DIGIT "." *DIGIT
    #   cell-2 = *DIGIT "." *DIGIT
    #   cell-3 = *DIGIT "." *DIGIT
    #   cell-4 = *DIGIT "." *DIGIT
    #   cell-5 = *DIGIT "." *DIGIT
    #   cell-6 = *DIGIT "." *DIGIT
    #   cell-7 = *DIGIT "." *DIGIT
    #   cell-8 = *DIGIT "." *DIGIT
    #   cell-9 = *DIGIT "." *DIGIT
    #   cell-10 = *DIGIT "." *DIGIT
    #   cell-11 = *DIGIT "." *DIGIT
    # """,
