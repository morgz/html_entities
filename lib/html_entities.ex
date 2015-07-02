defmodule HtmlEntities do
  @moduledoc """
  Decode HTML entities in a string.

  ## Examples

      iex> "Tom &amp; Jerry" |> HtmlEntities.decode
      "Tom & Jerry"
      iex> "&#161;Ay, caramba!" |> HtmlEntities.decode
      "¡Ay, caramba!"
  """

  @doc "Decode HTML entities in a string."
  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.replace(~r/\&[^\s]+;/r, string, &replace_entity/1)
  end

  html_entities_list_path = Path.join(__DIR__, "html_entities_list.txt")

  codes = File.stream!(html_entities_list_path) |> Enum.reduce [], fn(line, acc) ->
    [name, character, codepoint] = :binary.split(line, ",", [:global])
    :lists.keystore(name, 1, acc, {name, character, String.rstrip(codepoint)})
  end


  for {name, character, codepoint} <- codes do
    entity = "&#{name};"
    codepoint_entity = "&##{codepoint};"
    defp replace_entity(unquote(entity)), do: unquote(character)
    defp replace_entity(unquote(codepoint_entity)), do: unquote(character)
  end
end
