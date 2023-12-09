defmodule Day7 do
  def parse_hand(hand) do
    cards = String.codepoints(hand)

    type =
      Enum.frequencies(cards)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sort(&(&1 > &2))
      |> case do
        [5] -> :five_kind
        [4, 1] -> :four_kind
        [3, 2] -> :full_house
        [3 | _] -> :three_kind
        [2, 2, 1] -> :two_pair
        [2 | _] -> :one_pair
        _ -> :high
      end

    {type, cards}
  end

  def value(item) do
    case item do
      :five_kind -> 6
      :four_kind -> 5
      :full_house -> 4
      :three_kind -> 3
      :two_pair -> 2
      :one_pair -> 1
      :high -> 0
      "A" -> 12
      "K" -> 11
      "Q" -> 10
      "J" -> 9
      "T" -> 8
      "9" -> 7
      "8" -> 6
      "7" -> 5
      "6" -> 4
      "5" -> 3
      "4" -> 2
      "3" -> 1
      "2" -> 0
    end
  end

  def greater?({kind1, cards1}, {kind2, cards2}) when kind1 == kind2 do
    greater?(cards1, cards2)
  end

  def greater?({kind1, _}, {kind2, _}) do
    value(kind1) > value(kind2)
  end

  def greater?([card1 | cards1], [card2 | cards2]) do
    cond do
      value(card1) > value(card2) -> true
      value(card1) < value(card2) -> false
      true -> greater?(cards1, cards2)
    end
  end
end

res =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split/1)
  |> Enum.map(fn [hand, bid] ->
    {bid, Day7.parse_hand(hand)}
  end)
  |> Enum.sort(fn {_, hand1}, {_, hand2} -> Day7.greater?(hand2, hand1) end)
  |> Enum.with_index()
  |> Enum.map(fn {{bid, _}, idx} -> String.to_integer(bid) * (idx + 1) end)
  |> Enum.sum()

IO.inspect(res)
