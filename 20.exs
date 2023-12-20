defmodule Day20 do
  def new({[], modules, lows, highs}) do
    stack = modules[:broadcast] |> Enum.map(&{&1, :low})
    {stack, modules, lows + length(stack) + 1, highs}
  end

  def tick({[], modules, lows, highs}) do
    {[], modules, lows, highs}
  end

  def tick({[{module_name, pulse} | stack], modules, lows, highs}) do
    if not Map.has_key?(modules, module_name) do
      tick({stack, modules, lows, highs})
    else
      modules = Map.update!(modules, module_name, fn 
        {:flip_flop, dest, state} when pulse == :high -> {:flip_flop, dest, state} 
        {:flip_flop, dest, :high} when pulse == :low -> {:flip_flop, dest, :low} 
        {:flip_flop, dest, :low} when pulse == :low -> {:flip_flop, dest, :high} 
        {:conjunction, dest, inputs} -> {:conjunction, dest, inputs}
      end)

      all_high? = fn inputs ->
        inputs
        |> Enum.filter(&Map.has_key?(modules, &1))
        |> Enum.map(&Map.get(modules, &1))
        |> Enum.map(&elem(&1, 2))
        |> Enum.all?(&(&1 == :high))
      end

      new_pulses = case Map.get(modules, module_name) do
        {:flip_flop, dest, state} when pulse == :low -> Enum.map(dest, &{&1, state}) 
        {:conjunction, dest, inputs} ->
          if all_high?.(inputs) do
            Enum.map(dest, &{&1, :low})
          else
            Enum.map(dest, &{&1, :high})
          end
        _ -> []
      end
      new_highs = new_pulses |> Enum.map(&elem(&1, 1)) |> Enum.count(&(&1 == :high))
      new_lows = new_pulses |> Enum.map(&elem(&1, 1)) |> Enum.count(&(&1 == :low))
      tick({stack ++ new_pulses, modules, new_lows + lows, new_highs + highs})
    end 
  end

  def inputs(modules, {name, _, _}) do
    Enum.filter(modules, fn {_, _, destinations} -> name in destinations end)
    |> Enum.map(fn {name, _, _} -> name end)
  end
end

modules = IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(fn <<type::utf8, rest::binary>> ->
    [module_name, destinations] = String.split(rest, " -> ", trim: true)
    destinations = String.split(destinations, ", ")
    case type do
      ?b -> {"broadcast", :broadcast, destinations}
      ?% -> {module_name, :flip_flop, destinations}
      ?& -> {module_name, :conjunction, destinations}
    end
  end)
  |> then(fn modules ->
    Map.new(modules, fn module -> 
      case module do
        {_, :broadcast, destinations} -> {:broadcast, destinations}
        {name, :flip_flop, destinations} -> {name, {:flip_flop, destinations, :low}}
        {name, :conjunction, destinations} ->
          inputs = Day20.inputs(modules, module)
          {name, {:conjunction, destinations, inputs}}
        _ -> module
      end
    end)
  end)


{_, _, lows, highs} = 
  Enum.reduce(1..1000, {[], modules, 0, 0}, fn _x, acc -> 
    Day20.new(acc) |> Day20.tick()
  end)


IO.inspect({lows, highs, lows * highs})
