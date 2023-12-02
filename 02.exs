parse_line = fn line ->
  Regex.run(~r/Game (\d+): (.*)/, line, capture: :all_but_first)
  |> (fn [game | rest] -> {String.to_integer(game), hd(rest)} end).()
  |> (fn {game, pulls} -> {game, String.split(pulls, [", ", "; "])} end).()
end

group_colors = fn pulls ->
  Enum.map(pulls, &String.split/1)
  |> Enum.group_by(&List.last/1, &(List.first(&1) |> String.to_integer()))
end

exceeds_capacity = fn %{"red" => reds, "green" => greens, "blue" => blues} ->
  Enum.max(reds) > 12 or Enum.max(greens) > 13 or Enum.max(blues) > 14
end

minimum_possible_bag = fn %{"red" => reds, "green" => greens, "blue" => blues} ->
  [Enum.max(reds), Enum.max(greens), Enum.max(blues)]
end

input = IO.read(:stdio, :all)
  |> String.split("\n", trim: true)
  |> Enum.map(input, parse_line)

result1 = Enum.map(fn {game, pulls} -> {game, group_colors.(pulls)} end)
  |> Enum.filter(fn {_, color_groups} -> not exceeds_capacity.(color_groups) end)
  |> Enum.map(fn {game, _} -> game end)
  |> Enum.sum()

result2 = Enum.map(fn {_, pulls} -> group_colors.(pulls) end)
  |> Enum.map(minimum_possible_bag)
  |> Enum.map(&Enum.product/1)
  |> Enum.sum()

IO.inspect(result1)
IO.inspect(result2)
