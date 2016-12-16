defmodule ValidTriangles do
  def count(input) do
    input
    |> String.split
    |> Enum.map(fn int -> elem(Integer.parse(int),0) end)
    |> Enum.chunk(3)
    |> Enum.map(fn triangle -> triangle?(triangle) end)
    |> Enum.filter(fn valid -> valid end)
    |> Enum.count
  end

  def triangle?(triangle) do
    a = Enum.at(triangle, 0)
    b = Enum.at(triangle, 1)
    c = Enum.at(triangle, 2)
    a + b > c and a + c > b and c + b > a
  end
end

System.argv
|> hd
|> File.read!
|> ValidTriangles.count
|> IO.inspect
