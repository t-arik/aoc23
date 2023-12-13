defmodule Day13 do
  def transpose(["" | _]), do: []

  def transpose(rows) do
    str = rows |> Enum.map(&String.first/1) |> Enum.join()
    [str | transpose(Enum.map(rows, &String.slice(&1, 1..-1)))]
  end

  def get_points_of_pattern(rows) do
    column_sum =
      transpose(rows)
      |> common_vertical_reflections()
      |> Enum.map(&(&1 * 100))
      |> Enum.sum()

    row_sum =
      common_vertical_reflections(rows)
      |> Enum.sum()

    column_sum + row_sum
  end

  def common_vertical_reflections(rows) do
    rows
    |> Enum.map(&veritcal_reflections/1)
    |> Enum.reduce(&MapSet.intersection(&1, &2))
    |> MapSet.to_list()
  end

  def veritcal_reflections(row) do
    slice = &String.slice(row, &1, &2)
    len = String.length(row)

    Enum.flat_map(1..div(len, 2), fn i ->
      [
        {i, slice.(0, i), slice.(i, i)},
        {len - i, slice.(len - i - i, i), slice.(len - i, i)}
      ]
    end)
    |> Enum.filter(fn {_idx, left, right} ->
      String.reverse(left) == right
    end)
    |> Enum.map(fn {idx, _left, _right} -> idx end)
    |> MapSet.new()
  end
end

IO.read(:stdio, :all)
|> String.trim()
|> String.split("\n\n", trim: true)
|> Enum.map(&String.split(&1, "\n", trim: true))
|> Enum.map(&Day13.get_points_of_pattern/1)
|> Enum.sum()
|> IO.inspect()
