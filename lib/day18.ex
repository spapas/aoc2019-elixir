defmodule Day18 do

  def read_input() do
    File.read!("day18.txt")
  end

  def input_to_map(input) do
    input |> String.split("\r\n") |> Enum.map( &String.graphemes/1) |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        Map.put(accx, {x, y}, v)
      end)
    end)
  end

  def map(), do: input_to_map(read_input())



  def get_start(mm) do
    [{start, _v}] = mm |> Enum.filter(fn {_k, v} -> v=="@" end)
    start
  end

  def get_initial_state(mm) do
    pos = get_start(mm)
    %{
      pos: pos,
      steps: 0,
      keys: MapSet.new()
    }
  end

  def get_next_state(%{pos: {x, y}, steps: steps, keys: keys}, mm) do
    case Map.get(mm, {x, y}) do
      v when v in [".", "@"] -> %{pos: {x, y}, steps: steps + 1, keys: keys}
      v when v >= "a" and v <= "z" -> %{pos: {x, y}, steps: steps + 1, keys: MapSet.put(keys, v)}
      v when v >= "A" and v <= "Z" -> if String.downcase(v) in keys do
          %{pos: {x, y}, steps: steps + 1, keys: keys}
        else
          nil
        end
      _ -> nil
    end
  end

  def get_next_states(%{pos: {x, y}, steps: steps, keys: keys}, mm) do
    p1 = {x - 1, y}
    p2 = {x + 1, y}
    p3 = {x, y - 1}
    p4 = {x, y + 1}
    [p1, p2, p3, p4]
    |> Enum.map(fn p ->
      get_next_state(%{ pos: p, steps: steps, keys: keys }, mm)
    end)
    |> Enum.filter(fn s -> s != nil end)
  end

  def get_doors(mm) do
    mm |>  Map.values |> MapSet.new |>  Enum.filter( &(&1>="A" and &1<="Z")) |> Enum.sort
  end

  def get_keys(mm) do
    mm |>  Map.values |> MapSet.new |> Enum.filter( &(&1>="a" and &1<="z")) |> Enum.sort
  end

  def get_other_things(mm) do
    mm |>  Map.values |> MapSet.new |> Enum.filter( &( (&1<"a" or &1 >"z") and ( &1<"A" or &1 >"Z")))
  end


  def part1() do
    input_to_map(read_input())

  end


  def part2() do

  end
end
