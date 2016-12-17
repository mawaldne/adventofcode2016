defmodule SectorCalculator do
  def count(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn encrypted_sector -> get_sector(encrypted_sector) end)
    |> Enum.sum
  end

  def get_sector(encrypted_sector) do
    captures = Regex.named_captures(~r/(?<characters>.+)-(?<sector>\d*)\[(?<checksum>.*)\]/, encrypted_sector)
    characters = captures["characters"]
    {sector, _} = Integer.parse(captures["sector"])
    checksum = captures["checksum"]

    cond do
      get_checksum(characters) == checksum -> sector
      true -> 0
    end
  end

  def get_checksum(characters) do
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
|> IO.inspect
