defmodule ElixirGodotParsers do
  import NimbleParsec

  document = utf8_string(empty(), min: 1)

  defparsec :tscn, document, debug: true
end
