[instructions_str | nodes_str] =
  IO.read(:eof)
  |> String.split("\n", trim: true)

instructions = String.codepoints(instructions_str)

nodes =
  Enum.map(nodes_str, &String.replace(&1, ["=", "(", ",", ")"], ""))
  |> Enum.map(&String.split/1)
  |> Map.new(fn [node, left, right] -> {node, {left, right}} end)

start_nodes =
  Map.keys(nodes)
  |> Enum.filter(&(String.last(&1) == "A"))

result =
  instructions
  |> Stream.cycle()
  |> Stream.with_index()
  |> Enum.reduce_while(start_nodes, fn {instruction, idx}, current_nodes ->
    end_nodes = Enum.filter(current_nodes, &(String.last(&1) == "Z"))
    if end_nodes != [] do
      IO.inspect({idx, end_nodes})
    end

    if length(current_nodes) == length(end_nodes) do
      {:halt, idx}
    else
      new_nodes =
        Enum.map(current_nodes, fn current_node ->
          {left, right} = nodes[current_node]

          case instruction do
            "L" -> left
            "R" -> right
          end
        end)
      {:cont, new_nodes}
    end
  end)

IO.inspect(result)
