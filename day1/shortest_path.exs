defmodule ShortestPath do
  @doc """
  Walk a 2D grid and find the shortest path from the origin to the
  final position
  """

  def path() do
    {:ok, body} = File.read 'input.txt'
    body
    |> String.split(", ")
    |> walk({0,0}, :north)
    |> calculate
  end

  def direction(:north, "R"), do: :east
  def direction(:north, "L"), do: :west
  def direction(:east, "R"), do: :south
  def direction(:east, "L"), do: :north
  def direction(:south, "R"), do: :west
  def direction(:south, "L"), do: :east
  def direction(:west, "R"), do: :north
  def direction(:west, "L"), do: :south

  def walk([],postion,_) do
    postion
  end

  def walk([movement|tl], position, facing) do
    {turning, distance_string} = String.next_grapheme(movement)
    {distance, _} = Integer.parse(distance_string)
    heading = direction(facing, turning)
    walk(tl, new_position(heading, position, distance), heading)
  end

  def new_position(:north, {x, y}, distance) do
    {x, y + distance}
  end

  def new_position(:east, {x, y}, distance) do
    {x + distance, y}
  end

  def new_position(:south, {x, y}, distance) do
    {x, y - distance}
  end

  def new_position(:west, {x, y}, distance) do
    {x - distance, y}
  end

  def calculate({x, y}) do
    abs(x) + abs(y)
  end
end

ShortestPath.path
|> IO.inspect
