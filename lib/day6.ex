defmodule Day6 do
  @test_input """
  COM)B
  B)C
  C)D
  D)E
  E)F
  B)G
  G)H
  D)I
  E)J
  J)K
  K)L
  """
  def input_to_tuples(inp) do
    inp
    |> String.split()
    |> Enum.map(&(String.split(&1, ")") |> List.to_tuple()))
  end

  def prepare_test_input() do
    @test_input |> input_to_tuples()
  end

  def read_input() do
    File.read!("day6.txt")
    |> input_to_tuples()
  end

  def make_input_map(prepared_input) do
    prepared_input |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()
  end

  def make_input_set(prepared_input) do
    prepared_input |> Enum.map(fn {_k, v} -> v end) |> MapSet.new()
  end

  def count_distance("COM", acc, _input_map), do: acc
  def count_distance(el, acc, input_map) do
    count_distance(Map.get(input_map, el), acc+1, input_map)
  end

  def day6() do
    input = read_input()
    input_map = input |> make_input_map()
    input_set = input |> make_input_set()
    input_set |> Enum.map(&(count_distance(&1, 0, input_map))) |> Enum.sum
  end

  def day6b() do
  end
end
