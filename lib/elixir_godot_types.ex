defmodule Bool do
  @type t :: %__MODULE__{value: integer()}
  defstruct value: 0
end

defmodule Int do
  @type t :: %__MODULE__{value: integer()}
  defstruct value: 0
end

defmodule Vector2 do
  @type t :: %__MODULE__{x: float(), y: float()}
  defstruct x: 0.0, y: 0.0
end

defmodule Rect2 do
  @type t :: %__MODULE__{x: float(), y: float(), width: float(), height: float()}
  defstruct x: 0.0, y: 0.0, width: 0.0, height: 0.0
end

defmodule Vector3 do
  @type t :: %__MODULE__{x: float(), y: float(), z: float()}
  defstruct x: 0.0, y: 0.0, z: 0.0
end

defmodule Transform2D do
  @type t :: %__MODULE__{x: Vector2.t(), y: Vector2.t(), origin: Vector2.t()}
  defstruct x: %Vector2{}, y: %Vector2{}, origin: %Vector2{}
end

defmodule Plane do
  @type t :: %__MODULE__{normal: Vector3.t(), d: float()}
  defstruct normal: %Vector3{}, d: 0.0
end

defmodule Quaternion do
  @type t :: %__MODULE__{x: float(), y: float(), z: float(), w: float()}
  defstruct x: 0.0, y: 0.0, z: 0.0, w: 0.0
end

defmodule AABB do
  @type t :: %__MODULE__{position: Vector3.t(), size: Vector3.t()}
  defstruct position: %Vector3{}, size: %Vector3{}
end

defmodule Basis do
  @type t :: %__MODULE__{x: Vector3.t(), y: Vector3.t(), z: Vector3.t()}
  defstruct x: %Vector3{}, y: %Vector3{}, z: %Vector3{}
end

defmodule Transform3D do
  @type t :: %__MODULE__{basis: Basis.t(), origin: Vector3.t()}
  defstruct basis: %Basis{}, origin: %Vector3{}
end

defmodule Color do
  @type t :: %__MODULE__{r: float(), g: float(), b: float(), a: float()}
  defstruct r: 0.0, g: 0.0, b: 0.0, a: 0.0
end

defmodule NodePath do
  @type t :: %__MODULE__{path: binary()}
  defstruct path: ""
end

defmodule RID do
  @type t :: %__MODULE__{id: integer()}
  defstruct id: 0
end

defmodule Object do
  @type t :: %__MODULE__{class_name: binary(), properties: list()}
  defstruct class_name: "", properties: []
end

defmodule Dictionary do
  @type t :: %__MODULE__{elements: list()}
  defstruct elements: []
end

defmodule Array do
  @type t :: %__MODULE__{elements: list()}
  defstruct elements: []
end

defmodule RawArray do
  @type t :: %__MODULE__{data: binary()}
  defstruct data: <<>>
end

defmodule Int32Array do
  @type t :: %__MODULE__{data: list(integer())}
  defstruct data: []
end

defmodule Int64Array do
  @type t :: %__MODULE__{data: list(integer())}
  defstruct data: []
end

defmodule Float32Array do
  @type t :: %__MODULE__{data: list(float())}
  defstruct data: []
end

defmodule Float64Array do
  @type t :: %__MODULE__{data: list(float())}
  defstruct data: []
end

defmodule StringArray do
  @type t :: %__MODULE__{data: list(binary())}
  defstruct data: []
end

defmodule Vector2Array do
  @type t :: %__MODULE__{data: list(Vector2.t())}
  defstruct data: []
end

defmodule Vector3Array do
  @type t :: %__MODULE__{data: list(Vector3.t())}
  defstruct data: []
end

defmodule ColorArray do
  @type t :: %__MODULE__{data: list(Color.t())}
  defstruct data: []
end
