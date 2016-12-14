defmodule ShortestPath do
  def path() do
    {:ok, body} = File.read 'input.txt'
    body
    |> String.split(", ")
    |> walk(:north, [{0,0}])
    |> calculate
  end

  def walk([ ], _, _),
    do: raise "None found"

  def walk([movement|tl], heading, visited) do
    {turning, distance_string} = String.next_grapheme(movement)
    {distance, _} = Integer.parse(distance_string)
    new_heading = direction(heading, turning)

    case find_intersection(new_heading, distance, visited) do
      {:found, current_position} -> current_position
      {:continue, new_visited} -> walk(tl, new_heading, new_visited)
    end
  end

  def find_intersection(heading, distance, visited) when distance > 0 do
    current_position = List.first(visited)
    next_position = new_position(heading, current_position, 1)

    if Enum.member?(visited, next_position) do
      {:found, next_position}
    else
      new_visited = [next_position] ++ visited
      find_intersection(heading, distance - 1, new_visited)
    end
  end

  def find_intersection(heading, distance, visited) when distance == 0 do
    {:continue, visited}
  end

  def direction(:north, "R"), do: :east
  def direction(:north, "L"), do: :west
  def direction(:east, "R"), do: :south
  def direction(:east, "L"), do: :north
  def direction(:south, "R"), do: :west
  def direction(:south, "L"), do: :east
  def direction(:west, "R"), do: :north
  def direction(:west, "L"), do: :south

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
