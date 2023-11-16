defmodule ElixirGodotParsers do
  import NimbleParsec

  defstruct [:file_descriptor, :external_resources, :internal_resources, :nodes, :connections]

  file_descriptor = utf8_string(empty(), min: 1)
  external_resources = utf8_string(empty(), min: 1)
  internal_resources = utf8_string(empty(), min: 1)
  nodes = utf8_string(empty(), min: 1)
  connections = utf8_string(empty(), min: 1)

  document = optional(file_descriptor)
    |> optional(external_resources)
    |> optional(internal_resources)
    |> optional(nodes)
    |> optional(connections)

  defparsec :tscn, document, debug: false
end
