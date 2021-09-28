defmodule Day24 do


  def read_input() do
    File.read!("day24.txt")
  end

  def test_input() do
"....#
#..#.
#..##
..#..
#...."
  end

  def input_to_map(input) do
    input |> String.split(["\r\n", "\n"]) |> Enum.map( &String.graphemes/1) |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        Map.put(accx, {x, y}, v)
      end)
    end)
  end

  def get_adj_points({x,y}) do
    [
      {x-1, y},
      {x+1, y},
      {x, y-1},
      {x, y+1},
    ]
  end

  def next_state_point(p, ".", map) do
    cnt = get_adj_points(p) |> Enum.filter(&(Map.get(map, &1) == "#")) |> Enum.count()
    if cnt == 1 or cnt == 2, do: "#", else: "."
  end

  def next_state_point(p, "#", map) do
    cnt = get_adj_points(p) |> Enum.filter(&(Map.get(map, &1) == "#")) |> Enum.count()
    if cnt == 1, do: "#", else: "."
  end

  def next_state(map) do
    map |> Enum.reduce(%{}, fn {p, v}, acc ->
      Map.put(acc, p, next_state_point(p, v, map))
    end)
  end

  def show_map(m) do

    for y <- 0..5 do
      for x <- 0..5 do

          IO.write(Map.get(m, {x, y}))

      end

      IO.write('\n')
    end
  end

  def part1_loop(map, states) do
    ns = next_state(map)
    if ns in states do
      ns
    else
      part1_loop(ns, MapSet.put(states,ns))
    end
  end

  def part1_calc(map) do
    Enum.map(map, fn {{x,y}, v} ->
      if v == "#" do
        Integer.pow(2, y*5+x)
      else
        0
      end
    end) |> Enum.sum()
  end

  def part1_test() do
    done = part1_loop(test_input |> input_to_map, MapSet.new)
    done |> show_map
    done |> part1_calc

  end

  def part1() do
    done = part1_loop(read_input |> input_to_map, MapSet.new)
    done |> show_map
    done |> part1_calc

  end

end
