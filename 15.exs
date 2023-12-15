defmodule Day14 do
  def hash(string) do
    string
    |> String.codepoints()
    |> Enum.reduce(0, fn <<char::utf8>>, acc ->
      rem((char + acc) * 17, 256)
    end)
  end
end

IO.read(:eof)
|> String.replace("\n", "")
|> String.split(",", trim: true)
|> Enum.map(&Day14.hash/1)
|> Enum.sum()
|> IO.inspect(charlists: :as_lists)
