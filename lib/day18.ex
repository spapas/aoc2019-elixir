defmodule Day18 do

  def read_input() do
    File.read!("day18.txt")
  end

  def input_to_map(input) do
    input |> String.split("\n") |> Enum.map( &String.graphemes/1) |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        Map.put(accx, {x, y}, v)
      end)
    end)
  end



  def get_start(mm) do
    [{start, _v}] = mm |> Enum.filter(fn {_k, v} -> v=="@" end)
    start
  end

  def get_initial_state(mm) do
    st = get_start(mm)
    %{
      pos: pos,
      steps: 0,
      keys: MapSet.new()
    }
  end

  def get_next_states(%{pos: {x, y}, steps: steps, keys: keys}, mm) do
    p1 = {x - 1, y}
    p2 = {x + 1, y}
    p3 = {x, y - 1}
    p4 = {x, y + 1}
  end


  def part1() do
    input_to_map(read_input())

  end


  def part2() do

  end
end
