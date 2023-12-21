defmodule Day21 do
  def get(garden, x, y) do
    max_y = tuple_size(garden)
    max_x = tuple_size(elem(garden, 0))
    if x >= 0 and y >= 0 and x < max_x and y < max_y do
      garden |> elem(y) |> elem(x)
    else
      "."
    end
  end

  def to_2d_tuple(list) do
    list
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def step(garden) do
    ys = 0..tuple_size(garden) - 1
    xs = 0..tuple_size(elem(garden, 0)) - 1
    Enum.map(ys, fn y -> 
      Enum.map(xs, fn x -> 
        cond do
          get(garden, x, y) == "#" -> "#"
          get(garden, x - 1, y) == "O" -> "O"
          get(garden, x + 1, y) == "O" -> "O"
          get(garden, x, y - 1) == "O" -> "O"
          get(garden, x, y + 1) == "O" -> "O"
          true -> "."
        end
      end)
    end) |> to_2d_tuple()
  end
end

garden = IO.read(:eof)
  |> String.replace("S", "O")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes/1)
  |> Day21.to_2d_tuple()
  
1..64
|> Enum.reduce(garden, fn _x, acc -> Day21.step(acc) end)
|> Tuple.to_list()
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(&Enum.count(&1, fn char -> char == "O" end))
|> Enum.sum()
|> IO.inspect()
