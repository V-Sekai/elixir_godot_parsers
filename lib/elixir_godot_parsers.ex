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
      utf8_string([], min: 1)
    ])

  property =
    concat(
      property_name,
      property_value
    )
    |> optional(
      choice([
        ignore(string(" ")),
        ignore(string("\n")),
        ignore(eos())
      ])
    )
    |> wrap()

    sub_resource =
      ignore(string("[sub_resource type=\""))
      |> utf8_string([], min: 1, until: string("\" id=\""))
      |> ignore(string("\" id=\""))
      |> utf8_string([], min: 1, until: string("\""))
      |> ignore(string("\""))
      |> optional(ignore(string("]")))
      |> repeat(property, separator: choice([string("\n"), eos()]))
      |> wrap()
      |> tag(:sub_resource)

    file_descriptor =
      gd_scene
      |> optional(load_steps)
      |> optional(format)
      |> optional(uid)
      |> ignore(optional(string(" ")))
      |> choice([ignore(string("]\r\n\r\n")), ignore(string("]"))])
      |> tag(:file_descriptor)

    standard_material_3d =
      ignore(string("[sub_resource type=\"StandardMaterial3D\" id=\""))
      |> utf8_string([], min: 1, until: string("\""))
      |> ignore(string("\""))
      |> optional(ignore(string("]")))
      |> repeat(property, separator: choice([string("\n"), eos()]))
      |> wrap()
      |> tag(:standard_material_3d)

    section =
      repeat(
        choice([
          ignore(string("\n\n")),
          utf8_char([])
        ])
      )
      |> tag(:section)

    document =
      concat(
        file_descriptor,
        repeat(
          concat(
            ignore(string("\n\n")),
            section
          )
        )
      )
      |> tag(:document)


  defparsec(:tscn, document, debug: false)
end
