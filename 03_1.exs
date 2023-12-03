get_symbol_positions = fn line ->
  Enum.with_index(line)
  |> Enum.filter(fn {elem, _index} -> elem != "." and Integer.parse(elem) == :error end)
  |> Enum.map(fn {_elem, index} -> index end)
end

input =
  IO.read(:stdio, :all)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))

# To tuple for constant time access
schematic = Enum.map(input, &List.to_tuple/1)
  |> List.to_tuple()

max_y = tuple_size(schematic) - 1
max_x = tuple_size(elem(schematic, 0)) - 1
in_schematic? = fn {x, y} ->
  0 <= x and 0 <= y and x <= max_x and y <= max_y
end

schematic_at = fn {x, y} ->
  elem(elem(schematic, y), x)
end

is_left_number? = fn {x, y} ->
  in_schematic?.({x - 1, y}) and Integer.parse(schematic_at.({x - 1, y})) != :error
end

find_leftmost_number_pos = fn {x, y} -> 
  {Enum.find(x..0//-1, fn dx -> not is_left_number?.({dx, y}) end), y}
end

num_positions =
  Enum.with_index(input)
  |> Enum.map(fn {line, y} -> {get_symbol_positions.(line), y} end)
  |> Enum.reject(fn {xs, _index} -> Enum.empty?(xs) end)
  |> Enum.flat_map(fn {xs, y} -> for x <- xs, do: {x, y} end)
  |> Enum.flat_map(fn {x, y} -> [ {x, y}, {x, y + 1}, {x + 1, y + 1}, {x + 1, y}, {x + 1, y - 1}, {x, y - 1}, {x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1} ] end)
  |> Enum.filter(in_schematic?)
  |> Enum.reject(&Integer.parse(schematic_at.(&1)) == :error)

unique_num_positions =
  Enum.reject(num_positions, fn {x, y} -> Enum.member?(num_positions, {x - 1, y}) end)
  |> Enum.map(find_leftmost_number_pos)
  |> Enum.dedup()
  |> Enum.map(fn {x, y} -> Enum.drop(Enum.at(input, y), x) end)
  |> Enum.map(&Enum.take_while(&1, fn char -> Integer.parse(char) != :error end))
  |> Enum.map(&Enum.join/1)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.inspect(unique_num_positions)
