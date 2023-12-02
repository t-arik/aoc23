to_calibration_value = fn str ->
  String.codepoints(str)
    |> Enum.map(&Integer.parse/1)
    |> Enum.filter(&(&1 != :error))
    |> Enum.map(fn {num, ""} -> num end)
    |> (fn nums -> 10 * hd(nums) + List.last(nums) end).()
end

replace_numbers = fn str ->
  str
    |> String.replace("one", "one1one")
    |> String.replace("two", "two2two")
    |> String.replace("three", "three3three")
    |> String.replace("four", "four4four")
    |> String.replace("five", "five5five")
    |> String.replace("six", "six6six")
    |> String.replace("seven", "seven7seven")
    |> String.replace("eight", "eight8eight")
    |> String.replace("nine", "nine9nine")
end

input = IO.read(:stdio, :all)

result1 = input
  |> String.split("\n", trim: true)
  |> Enum.map(to_calibration_value)
  |> Enum.sum()

result2 = input
  |> String.split("\n", trim: true)
  |> Enum.map(replace_numbers)
  |> Enum.map(to_calibration_value)
  |> Enum.sum()

IO.puts("Result 1: #{result1}")
IO.puts("Result 2: #{result2}")
