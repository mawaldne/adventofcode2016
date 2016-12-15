defmodule SecurityCode do
  def code(input) do
    input
    |> String.split
    |> collect_code(5, "")
  end

  def collect_code([], _, code), do: code
  def collect_code([instructions|tl], current_digit, code) do
    new_digit = run_instructions(String.graphemes(instructions), current_digit)
    collect_code(tl, new_digit, code <> Integer.to_string(new_digit))
  end

  def run_instructions([], current_digit), do: current_digit
  def run_instructions([inst|tl], current_digit) do
    run_instructions(tl, digit(current_digit, inst))
  end

  def digit(1, "R"), do: 2
  def digit(1, "D"), do: 4
  def digit(1, direction) when direction in ["U","L"], do: 1

  def digit(2, "U"), do: 2
  def digit(2, "R"), do: 3
  def digit(2, "D"), do: 5
  def digit(2, "L"), do: 1

  def digit(3, "L"), do: 2
  def digit(3, "D"), do: 6
  def digit(3, direction) when direction in ["U","R"], do: 3

  def digit(4, "U"), do: 1
  def digit(4, "R"), do: 5
  def digit(4, "D"), do: 7
  def digit(4, "L"), do: 4

  def digit(5, "U"), do: 2
  def digit(5, "R"), do: 6
  def digit(5, "D"), do: 8
  def digit(5, "L"), do: 4

  def digit(6, "U"), do: 3
  def digit(6, "R"), do: 6
  def digit(6, "D"), do: 9
  def digit(6, "L"), do: 5

  def digit(7, "U"), do: 4
  def digit(7, "R"), do: 8
  def digit(7, direction) when direction in ["D","L"], do: 7

  def digit(8, "U"), do: 5
  def digit(8, "R"), do: 9
  def digit(8, "D"), do: 8
  def digit(8, "L"), do: 7

  def digit(9, "U"), do: 6
  def digit(9, "L"), do: 8
  def digit(9, direction) when direction in ["D","R"], do: 9
end

System.argv
|> hd
|> File.read!
|> SecurityCode.code
|> IO.inspect
