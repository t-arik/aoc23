defmodule Day7 do
  def parse_hand(hand) do
    cards = String.codepoints(hand)

    is_joker = &(&1 == "J")
    type =
      cards
      |> Enum.reject(is_joker)
      |> Enum.frequencies
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sort(&(&1 > &2))
      |> case do
        [5] -> :five_kind
        [4 | _] -> :four_kind
        [3, 2] -> :full_house
        [3 | _] -> :three_kind
        [2, 2 | _] -> :two_pair
        [2 | _] -> :one_pair
        _ -> :high
      end

    better_type = case {type, Enum.count(cards, is_joker)} do
      {:four_kind, 1} -> :five_kind
      {:three_kind, 2} -> :five_kind
      {:three_kind, 1} -> :four_kind
      {:two_pair, 1} -> :full_house
      {:one_pair, 3} -> :five_kind
      {:one_pair, 2} -> :four_kind
      {:one_pair, 1} -> :three_kind
      {:high, 5} -> :five_kind
      {:high, 4} -> :five_kind
      {:high, 3} -> :four_kind
      {:high, 2} -> :three_kind
      {:high, 1} -> :one_pair
      _ -> type
    end

    {better_type, cards}
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
      "T" -> 9
      "9" -> 8
      "8" -> 7
      "7" -> 6
      "6" -> 5
      "5" -> 4
      "4" -> 3
      "3" -> 2
      "2" -> 1
      "J" -> 0
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
