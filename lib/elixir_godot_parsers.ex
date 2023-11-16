defmodule ElixirGodotParsers do
  import NimbleParsec

  defstruct [:load_steps, :format, :uid]

  defp not_space(<<char::utf8, _rest::binary>>, context, _, _) when char != ?\s, do: {:cont, context}
  defp not_space(_, context, _, _), do: {:halt, context}

  defp not_quote(<<?", _::binary>>, context, _, _), do: {:halt, context}
  defp not_quote(_, context, _, _), do: {:cont, context}

  gd_scene =
    ignore(string("["))
    |> repeat_while(utf8_char([]), {:not_space, []})
    |> ignore(string(" "))
    |> wrap()
    |> tag(:gd_scene)

  load_steps =
    ignore(string("load_steps="))
    |> integer(min: 1)
    |> ignore(string(" "))
    |> tag(:load_steps)

  format =
    ignore(string("format="))
    |> integer(min: 1)
    |> ignore(string(" "))
    |> tag(:format)

  uid =
    ignore(string("uid=\""))
    |> repeat_while(utf8_char([]), {:not_quote, []})
    |> ignore(string("\""))
    |> tag(:uid)


  file_descriptor =
    gd_scene
    |> optional(load_steps)
    |> optional(format)
    |> optional(uid)
    |> tag(:file_descriptor)

  external_resources = utf8_string(empty(), min: 1)
  internal_resources = utf8_string(empty(), min: 1)
  nodes = utf8_string(empty(), min: 1)
  connections = utf8_string(empty(), min: 1)

  document = file_descriptor
    |> optional(external_resources)
    |> optional(internal_resources)
    |> optional(nodes)
    |> optional(connections)

  defparsec(:tscn, document, debug: false)
end
