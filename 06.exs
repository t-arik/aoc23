input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split/1)
  |> Enum.map(&Enum.drop(&1, 1))

get_winnable = fn {time, record} ->
    Enum.to_list(1..time)
    |> Enum.filter(&(&1 * (time - &1) > record))
    |> length()
end

result1 =
  Enum.map(input, fn ls -> Enum.map(ls, &String.to_integer/1) end)
  |> Enum.zip()
  |> Enum.map(get_winnable)
  |> Enum.product()

result2 =
  Enum.map(input, &Enum.join/1)
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple()
  |> get_winnable.()

IO.inspect(result1)
IO.inspect(result2)
