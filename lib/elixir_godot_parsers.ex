defmodule ElixirGodotParsers do
  use AbnfParsec,
    abnf: """
    gd-scene = "[" *SP "gd_scene" 1*(SP key-value) *SP "]"
    key-value = key "=" value
    key = "load_steps" / "format" / "uid" / "path" / "type" / "id" / "name" / "parent" / "signal" / "from" / "to" / "method"
    value = QUOTEDSTRING / NUMBER / uid

    uid = DQUOTE "uid://" 1*ALPHANUM DQUOTE
    QUOTEDSTRING = DQUOTE *QUOTEDCHAR DQUOTE
    NUMBER = 1*DIGIT
    DIGIT = %x30-39
    DQUOTE = %x22
    QUOTEDCHAR = CHAR / SP
    CHAR = %x20-21 / %x23-7E
    ALPHANUM = ALPHA / DIGIT
    ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
    SP = %x20
    """,
    unbox: [
      "load_steps",
      "format",
      "uid",
      "path",
      "type",
      "id",
      "name",
      "parent",
      "signal",
      "from",
      "to",
      "method"
    ],
    debug: false
end

defmodule ElixirGodot do
  def parse_gd_scene(text), do: ElixirGodotParsers.gd_scene(text)
  def parse_sub_resource(text), do: ElixirGodotParsers.sub_resource(text)
  def parse_node(text), do: ElixirGodotParsers.node(text)
  def parse_connection(text), do: ElixirGodotParsers.connection(text)

  def parse_ext_resource(input) do
    case ElixirGodotParsers.ext_resource(input) do
      {:ok, result} ->
        path = Map.get(result, "path")
        type = Map.get(result, "type")
        id = Map.get(result, "id")
        {:ok, %{path: path, type: type, id: id}}

      error ->
        error
    end
  end

  def tscn_parser(tscn_string) do
    tscn_string
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    case line do
      ~r/^\[gd_scene/ -> parse_gd_scene(line)
      ~r/^\[ext_resource/ -> parse_ext_resource(line)
      ~r/^\[sub_resource/ -> parse_sub_resource(line)
      ~r/^\[node/ -> parse_node(line)
      ~r/^\[connection/ -> parse_connection(line)
      _ -> {:ok, line}
    end
  end
end
