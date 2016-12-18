defmodule SectorCalculator do
  def count(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn encrypted_sector -> room(encrypted_sector) end)
    |> Enum.filter(fn {:room, _, _, checksum, calculate_checksum} -> checksum == calculate_checksum end)
    |> Enum.map(fn {:room, characters, sector, _, _} -> {sector, decode(characters, sector)} end)
  end

  def decode(characters, sector) do
    value = rem(sector, 26)
    characters
    |> String.downcase
    |> String.replace("-"," ")
    |> String.graphemes
    |> Enum.map(fn char -> encode_point(char, value) end)
    |> Enum.join
  end

  defp encode_point(" ", _), do: " "
  defp encode_point(codepoint, value) do
    << p >> = codepoint
    << _encode_point(p + value) >>
  end

  defp _encode_point(p) when p > 122, do: p - 26
  defp _encode_point(p), do: p

  defp room(encrypted_sector) do
    captures = Regex.named_captures(~r/(?<characters>.+)-(?<sector>\d*)\[(?<checksum>.*)\]/, encrypted_sector)
    characters = captures["characters"]
    {sector, _} = Integer.parse(captures["sector"])
    checksum = captures["checksum"]

    {:room, characters, sector, checksum, calculate_checksum(characters)}
  end

  defp calculate_checksum(characters) do
    characters
    |> String.replace("-","")
    |> String.graphemes
    |> Enum.group_by(fn char -> char end)
    |> Enum.map(fn {char, chars} -> {char, length(chars)} end)
    |> Enum.sort(fn {a,a_count}, {b, b_count} ->
      if a == b do
        a <= b
      else
        b_count <= a_count
      end
    end)
    |> Enum.map(fn {char, _} -> char end)
    |> Enum.take(5)
    |> Enum.join("")
  end
end

System.argv
|> hd
|> File.read!
|> SectorCalculator.count
|> IO.inspect(limit: :infinity)

