defmodule Day19 do
  def build_flow_function(string) do
    rules = String.split(string, ",")
      |> Enum.map(fn rule ->
        case String.split(rule, ["<", ">", ":"]) do
          [category, number, next] ->
            operator = if(String.contains?(rule, "<"), do: &Kernel.</2, else: &Kernel.>/2)
            number = String.to_integer(number)
            {category, operator, number, next}
          [next] -> next
        end
      end)

    else_case = List.last(rules)
    rules = Enum.drop(rules, -1)

    fn [x, m, a, s] ->
      reslut = Enum.find(rules, fn {category, operator, number, _} -> 
        case category do
          "x" -> operator.(x, number)
          "m" -> operator.(m, number)
          "a" -> operator.(a, number)
          "s" -> operator.(s, number)
        end
      end)
      if reslut == nil do
        else_case
      else
        {_,_,_,next} = reslut
        next
      end
  end
  end

  def accepted?(workflows, part) do
    accepted?(workflows, "in", part)
  end

  def accepted?(_, "A", _) do
    true
  end

  def accepted?(_, "R", _) do
    false
  end

  def accepted?(workflows, workflow, part) do
    result = workflows[workflow].(part)
    accepted?(workflows, result, part)
  end
end

[workflows, parts] =
  IO.read(:eof)
  |> String.split("\n\n")

workflows =
  workflows
  |> String.split("\n")
  |> Enum.map(fn workflow -> 
    [key, flow] = String.split(workflow, ["{", "}"], trim: true)
    {key, Day19.build_flow_function(flow)}
  end)
  |> Map.new()

parts = parts
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> 
    line
    |> String.replace(["x=", "m=", "a=", "s=", "{", "}"], "")
    |> String.split(",") 
    |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.filter(&Day19.accepted?(workflows, &1))
  |> Enum.map(&Enum.sum/1)
  |> Enum.sum()
  |> IO.inspect()

