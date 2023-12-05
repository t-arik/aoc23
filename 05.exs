[seeds_str | rest] =
  IO.read(:eof)
  |> String.split("\n", trim: true)

seeds =
  String.replace(seeds_str, "seeds: ", "")
  |> String.split()
  |> Enum.map(&String.to_integer/1)

by_seed_map = fn element, acc ->
  if String.contains?(element, "map") do
    {:cont, acc, []}
  else
    {:cont, acc ++ [element]}
  end
end

parse_range = fn range_str ->
  String.split(range_str)
  |> Enum.map(&String.to_integer/1)
  |> (fn [dst, src, len] -> {src..(src + len - 1)//1, dst} end).()
end

maps =
  Enum.chunk_while(rest, [], by_seed_map, &{:cont, &1, []})
  |> Enum.drop(1)
  |> Enum.map(&Enum.map(&1, parse_range))

get_offset = fn map, number ->
  case Enum.filter(map, fn {src_range, _} -> number in src_range end) do
    [{src_range, dst}] -> dst - src_range.first
    [] -> 0
  end
end

# Partitions the range into a list of ranges (elements) with the following properties:
#   - The element is a subset of range
#   - The element is either a subset of partitioner or distinct from partitioner
partition_range = fn range, partitioner ->
  case {(partitioner.first - 1) in range, (partitioner.last + 1) in range} do
    {false, false} ->
      [range]

    {true, false} ->
      [range.first..(partitioner.first - 1)//1, partitioner.first..range.last//1]

    {false, true} ->
      [range.first..partitioner.last//1, (partitioner.last + 1)..range.last//1]

    {true, true} ->
      [
        range.first..(partitioner.first - 1)//1,
        partitioner,
        (partitioner.first + 1)..range.last//1
      ]
  end
  |> Enum.reject(&Enum.empty?/1)
end

get_destination_for_range = fn map, range ->
  Enum.reduce(map, List.wrap(range), fn {src_range, _}, ranges ->
    Enum.flat_map(ranges, &partition_range.(&1, src_range))
  end)
  |> Enum.map(&Range.shift(&1, get_offset.(map, &1.first)))
end

seeds_as_ranges =
  Enum.chunk_every(seeds, 2)
  |> Enum.map(fn [start, len] -> start..(start + len - 1)//1 end)

result1 =
  Enum.map(seeds, fn seed ->
    Enum.reduce(maps, seed, fn map, number ->
      number + get_offset.(map, number)
    end)
  end)
  |> Enum.min()

result2 =
  Enum.flat_map(seeds_as_ranges, fn seed ->
    Enum.reduce(maps, [seed], fn map, ranges ->
      Enum.flat_map(ranges, &get_destination_for_range.(map, &1))
    end)
  end)
  |> Enum.map(& &1.first)
  |> Enum.min()

IO.inspect(result1)
IO.inspect(result2, charlists: :as_lists)
