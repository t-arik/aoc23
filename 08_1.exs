[instructions_str | nodes_str] =
  IO.read(:eof)
  |> String.split("\n", trim: true)

instructions = String.codepoints(instructions_str)

nodes =
  Enum.map(nodes_str, &String.replace(&1, ["=", "(", ",", ")"], ""))
  |> Enum.map(&String.split/1)
  |> Map.new(fn [node, left, right] -> {node, {left, right}} end)

result1 = instructions
|> Stream.cycle()
|> Stream.with_index()
|> Enum.reduce_while("AAA", fn {instruction, idx}, current_node ->
  {left, right} = nodes[current_node]

  cond do
    current_node == "ZZZ" -> {:halt, idx}
    instruction == "L" -> {:cont, left}
    instruction == "R" -> {:cont, right}
  end
end)

IO.inspect(result1)
