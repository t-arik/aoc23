defmodule Day12 do
  def branch({spr, grp}) do
    arrangements({"#" <> spr, grp}) + arrangements({"." <> spr, grp})
  end

  def arrangements(input = {springs, group_sizes}) do
    case input do
      {"", []} -> 1
      {"#" <> _, []} -> 0
      {"#" <> _, [0 | _]} -> 0
      {_, [0 | groups]} -> arrangements({springs, groups})
      {"", _} -> 0
      {"#" <> "." <> rest_s, [1 | rest_g]} -> arrangements({rest_s, rest_g})
      {"#" <> "." <> _, _} -> 0
      {"#" <> "?" <> rest_s, [1 | rest_g]} -> arrangements({"." <> rest_s, rest_g})
      {"#" <> "?" <> rest_s, [group | rest_g]} -> arrangements({"#" <> rest_s, [group - 1 | rest_g]})
      {"#" <> rest_s, [size | rest_g]} -> arrangements({rest_s, [size - 1 | rest_g]})
      {"." <> rest_s, _} -> arrangements({rest_s, group_sizes})
      {"?" <> rest, _} -> branch({rest, group_sizes})
    end
  end
end

IO.read(:eof)
|> String.split("\n", trim: true)
|> Enum.map(&String.split/1)
|> Enum.map(fn [springs, condition] ->
  {springs, condition |> String.split(",") |> Enum.map(&String.to_integer/1)}
end)
|> Enum.map(&Day12.arrangements/1)
|> Enum.sum()
|> IO.inspect()
