defmodule Day16 do
  def read_input() do
    File.read!("day16.txt")
    |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def get_pattern
end
