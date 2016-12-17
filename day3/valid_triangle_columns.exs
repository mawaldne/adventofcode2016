defmodule ValidTriangleColumns do
  def count(input) do
    input
    |> String.split
    |> Enum.map(fn int -> elem(Integer.parse(int),0) end)
    |> Enum.chunk(9)
    |> Enum.map(fn [a,b,c,d,e,f,g,h,i] -> [a,d,g,b,e,h,c,f,i] end)
    |> List.flatten
    |> Enum.chunk(3)
    |> Enum.filter(fn [a,b,c] -> a + b > c and a + c > b and c + b > a end)
    |> Enum.count
  end
end

System.argv
|> hd
|> File.read!
|> ValidTriangleColumns.count
|> IO.inspect
