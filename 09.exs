defmodule Day9 do
  def build_difference(history) do
    Enum.zip(history, Enum.drop(history, 1))
    |> Enum.map(fn {left, right} -> right - left end)
  end

  def build_full_history(history) do
    if Enum.reject(history, &(&1 == 0)) |> Enum.empty?() do
      [history]
    else
      [history | build_difference(history) |> build_full_history()]
    end
  end

  def extrapolate_right(full_history) do
    full_history
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  def extrapolate_left(full_history) do
    full_history
    |> Enum.map(&List.first/1)
    |> Enum.reverse()
    |> Enum.reduce(fn elem, acc -> elem - acc end)
  end
end

histories =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  |> Enum.map(&Day9.build_full_history/1)

histories
|> Enum.map(&Day9.extrapolate_right/1)
|> Enum.sum()
|> IO.inspect()

histories
|> Enum.map(&Day9.extrapolate_left/1)
|> Enum.sum()
|> IO.inspect()
