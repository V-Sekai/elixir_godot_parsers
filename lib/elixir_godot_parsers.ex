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

  property_name =
    utf8_string([], min: 1, until: string(" = "))
    |> ignore(string(" = "))

  property_value =
    choice([
      string("\"")
      |> utf8_string([], min: 1, until: string("\""))
      |> ignore(string("\"")),
      integer(min: 1),
      utf8_string([], min: 1) # Add this line to handle unquoted strings
    ])

  property =
    utf8_string([], min: 1, until: string(" = "))
    |> ignore(string(" = "))
    |> utf8_string([], min: 1, until: string("\n"))
    |> wrap()

  sub_resource =
    ignore(string("[sub_resource type=\""))
    |> utf8_string([], min: 1, until: string("\" id=\""))
    |> ignore(string("\" id=\""))
    |> utf8_string([], min: 1, until: string("\"]\r\n"))
    |> ignore(string("\"]\r\n")) # Changed this line
    |> repeat(property)
    |> wrap()
    |> tag(:sub_resource)

  file_descriptor =
    gd_scene
    |> optional(load_steps)
    |> optional(format)
    |> optional(uid)
    |> choice([ignore(string("]\r\n\r\n")), ignore(string("]"))])
    |> tag(:file_descriptor)

  document =
    concat(
      file_descriptor,
      optional(sub_resource)
    )
    |> tag(:document)

  defparsec(:tscn, document, debug: false)
end
