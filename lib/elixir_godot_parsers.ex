defmodule ElixirGodotParsers do
  use AbnfParsec,
    abnf: """
    gd-scene = 1*section

    section = "[" *SP "gd_scene" 1*(SP key-value) "]" section-terminator

    section-terminator = CRLF / LF ; Use appropriate line terminator based on your needs

    key-value = key "=" value
    key = "load_steps" / "format" / "uid" / "path" / "type" / "id" / "name" / "parent" / "signal" / "from" / "to" / "method"
    value = QUOTEDSTRING / NUMBER / uid

    uid = DQUOTE "uid://" *ALPHANUM DQUOTE
    QUOTEDSTRING = DQUOTE *QUOTEDCHAR DQUOTE
    NUMBER = 1*DIGIT
    DIGIT = %x30-39
    DQUOTE = %x22
    QUOTEDCHAR = CHAR / SP
    CHAR = %x20-21 / %x23-7E
    ALPHANUM = ALPHA / DIGIT
    ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
    SP = %x20
    CRLF = %x0D.0A ; Carriage Return + Line Feed
    LF = %x0A ; Line Feed
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
  def parse_tscn_scene(text), do: ElixirGodotParsers.gd_scene(text)
end
