defmodule ElixirGodotParsers do
  use AbnfParsec,
    abnf: """
    gd-scene = "[gd_scene load_steps=" load-steps " format=" format "]"
    load-steps = 1*DIGIT ; one or more digits
    format = 1*DIGIT ; one or more digits
    """,
    unbox: ["load-steps", "format"],
    ignore: [" "],
    parse: :gd_scene
end

defmodule ElixirGodot do
  def tscn_parser(tscn_string) do
    tscn_string
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    case line do
      ~r/^\[gd_scene/ -> ElixirGodotParsers.parse(:gd_scene)
      _ -> {:ok, line}
    end
  end
end
