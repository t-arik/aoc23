defmodule Day14 do
  def tranpose_strings(["" | _]) do
    []
  end

  def tranpose_strings(strings) do
    [
      Enum.map(strings, &String.first/1) |> Enum.join()
      | Enum.map(strings, &String.slice(&1, 1..-1)) |> tranpose_strings()
    ]
  end

  def move_rocks(string) do
    string
    |> String.split("#")
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.sort() |> Enum.join() |> String.reverse()
    end)
    |> Enum.join("#")
  end
end

IO.read(:eof)
|> String.split("\n", trim: true)
|> Day14.tranpose_strings()
|> Enum.map(&Day14.move_rocks(&1))
|> Day14.tranpose_strings()
|> Enum.reverse()
|> Enum.with_index()
|> Enum.map(fn {line, index} ->
  {line |> String.graphemes() |> Enum.count(&(&1 == "O")), index}
end)
|> Enum.map(fn {count, index} ->
  count * (index + 1)
end)
|> Enum.sum()
|> IO.inspect()
