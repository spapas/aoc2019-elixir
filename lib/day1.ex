defmodule Day1 do
  def day1 do
    File.read!("day1.txt")
    |> String.split()
    |> Enum.map(&(div(String.to_integer(&1), 3) - 2))
    |> Enum.sum()
  end

  def day1b_get_mass(val, acc) do
    new_val = div(val, 3) - 2

    if new_val <= 0 do
      acc
    else
      day1b_get_mass(new_val, acc + new_val)
    end
  end

  def day1b do
    File.read!("day1.txt")
    |> String.split()
    |> Enum.map(&(&1 |> String.to_integer() |> day1b_get_mass(0)))
    |> Enum.sum()
  end
end
