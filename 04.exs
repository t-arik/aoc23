parse_input = fn line ->
  [card_str, winning_str, numbers_str | []] = String.split(line, [": ", " | "], trim: true)
  card_idx = String.split(card_str) |> List.last() |> String.to_integer()
  winning = String.split(winning_str) |> Enum.map(&String.to_integer/1)
  numbers = String.split(numbers_str) |> Enum.map(&String.to_integer/1)
  {card_idx, winning, numbers}
end

get_match_count = fn {_, winning, my_numbers} ->
  my_numbers
  |> Enum.filter(&Enum.member?(winning, &1))
  |> Enum.count()
end

cards =
  IO.read(:stdio, :all)
  |> String.split("\n", trim: true)
  |> Enum.map(parse_input)

result1 =
  Enum.map(cards, get_match_count)
  |> Enum.reject(&(&1 == 0))
  |> Enum.map(&(2 ** (&1 - 1)))
  |> Enum.sum()

initial_duplicates = List.duplicate(1, length(cards))

result2 =
  Enum.reduce(cards, {[], initial_duplicates}, fn card, {done, [current | duplicates]} ->
    matches = get_match_count.(card)
    {affected, rest} = Enum.split(duplicates, matches)
    {done ++ [current], Enum.map(affected, &(&1 + current)) ++ rest}
  end)
  |> elem(0)
  |> Enum.sum()

IO.inspect(result1, charlists: :as_lists)
IO.inspect(result2, charlists: :as_lists)
