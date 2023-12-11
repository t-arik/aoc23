defmodule Day11 do
  def transpose([[] | _]) do
    []
  end

  def transpose(matrix) do
    [Enum.map(matrix, &hd/1) | transpose(Enum.map(matrix, &tl/1))]
  end

  def expand(matrix) do
    matrix
    |> Enum.flat_map(fn line ->
      if Enum.count(line, &("." == &1)) == length(line) do
        [line, line]
      else
        [line]
      end
    end)
  end
end

galaxies =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes/1)
  |> Day11.expand()
  |> Day11.transpose()
  |> Day11.expand()
  |> Enum.with_index()
  |> Enum.flat_map(fn {line, y} ->
    Enum.with_index(line)
    |> Enum.map(fn {char, x} -> {char, x, y} end)
  end)
  |> Enum.filter(fn {char, _, _} -> char == "#" end)
  |> Enum.with_index()
  |> Enum.map(fn {{_, x, y}, idx} -> {idx, x, y} end)

for {idx1, x1, y1} <- galaxies, {idx2, x2, y2} <- galaxies, idx1 < idx2 do
  abs(x1 - x2) + abs(y1 - y2)
end
|> Enum.sum()
|> IO.inspect()
