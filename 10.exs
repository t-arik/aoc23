defmodule Day10 do
  def parse_input(input) when is_binary(input) do
    parse_pipe =
      &case &1 do
        "|" -> :vertical
        "-" -> :horizaontal
        "L" -> :north_east
        "J" -> :north_west
        "7" -> :south_west
        "F" -> :south_east
        "." -> :ground
        "S" -> :start
      end

    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.map(&1, parse_pipe))
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def get_map_bounds(map) do
    max_y = tuple_size(map) - 1
    max_x = tuple_size(elem(map, 0)) - 1
    {max_x, max_y}
  end

  def at(map, x, y) when is_tuple(map) do
    {max_x, max_y} = get_map_bounds(map)

    if x < 0 or y < 0 or max_x < x or max_y < y do
      :out_of_bounds
    else
      map |> elem(y) |> elem(x)
    end
  end

  def starting_position(map) do
    {max_x, max_y} = get_map_bounds(map)

    all_positions = for y <- 0..max_y, x <- 0..max_x, do: {x, y}
    Enum.find(all_positions, fn {x, y} -> Day10.at(map, x, y) == :start end)
  end

  def find_path_to_start(current = {x, y}, previous = {px, py}, map) do
    if at(map, x, y) == :start and at(map, px, py) != :start do
      [current]
    else
      next = traverse(current, previous, map)
      [current | find_path_to_start(next, current, map)]
    end
  end

  def traverse({x, y}, ignore = {_x, _y}, map) do
    if at(map, x, y) == :start do
      {new_x, new_y, _} =
        [
          {x, y - 1, [:vertical, :south_west, :south_east]},
          {x, y + 1, [:vertical, :north_east, :north_west]},
          {x + 1, y, [:horizaontal, :south_west, :north_west]},
          {x - 1, y, [:horizaontal, :north_east, :south_east]}
        ]
        |> Enum.find(fn {x, y, expected_pipes} ->
          at(map, x, y) in expected_pipes
        end)

      {new_x, new_y}
    else
      case at(map, x, y) do
        :vertical -> [{x, y - 1}, {x, y + 1}]
        :horizaontal -> [{x - 1, y}, {x + 1, y}]
        :north_east -> [{x, y - 1}, {x + 1, y}]
        :north_west -> [{x, y - 1}, {x - 1, y}]
        :south_west -> [{x, y + 1}, {x - 1, y}]
        :south_east -> [{x, y + 1}, {x + 1, y}]
      end
      |> Enum.reject(&(ignore == &1))
      |> List.first()
    end
  end
end

map = IO.read(:eof) |> Day10.parse_input()
start = Day10.starting_position(map)

Day10.find_path_to_start(start, start, map)
|> length()
|> then(&div(&1 - 1, 2))
|> IO.inspect()
