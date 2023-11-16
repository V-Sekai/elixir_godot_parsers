defmodule ElixirGodotParsers do
  import NimbleParsec

  defstruct [:load_steps, :format, :uid]

  load_descriptor =
    ignore(string("[gd_scene"))
    |> ignore(string(" "))

  load_steps =
    ignore(string("load_steps="))
    |> utf8_string([], min: 1, max: 10)
    |> ignore(string(" "))

  format =
    ignore(string("format="))
    |> utf8_string([], min: 1, max: 10)
    |> ignore(string(" "))

  uid =
    ignore(string("uid=\""))
    |> utf8_string([], min: 1)
    |> ignore(string("\""))

  file_descriptor = load_descriptor
    |> concat(load_steps)
    |> concat(format)
    |> concat(uid)

  external_resources = utf8_string(empty(), min: 1)
  internal_resources = utf8_string(empty(), min: 1)
  nodes = utf8_string(empty(), min: 1)
  connections = utf8_string(empty(), min: 1)

  document =
    optional(file_descriptor)
    |> optional(external_resources)
    |> optional(internal_resources)
    |> optional(nodes)
    |> optional(connections)

  defparsec(:tscn, document, debug: false)
end
