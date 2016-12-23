defmodule RepeatCodeLeast do
  def correct(input) do
    letters =
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.join
    |> String.graphemes

    0..7
    |> Enum.map(fn char_num -> letters |> Enum.drop(char_num) |> Enum.take_every(8) end)
    |> Enum.map(fn chars -> Enum.group_by(chars, fn char -> char end) end)
    |> Enum.map(fn char_map -> Enum.map(char_map, fn {char, char_list} -> {char, length(char_list)} end) end)
    |> Enum.map(fn char_list -> Enum.min_by(char_list, fn {_char, length} -> length end) end)
    |> Enum.map(fn {char, _ } -> char end)
    |> Enum.join

  end
end

System.argv
|> hd
|> File.read!
|> RepeatCodeLeast.correct
|> IO.inspect(limit: :infinity)

