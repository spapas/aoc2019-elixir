defmodule Day24b do


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
    input |> String.split(["\r\n", "\n"]) |> Enum.map( &String.graphemes/1)
    |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        if {x, y} == {2,2} do
          accx
        else
          Map.put(accx, {0, x, y}, v)
        end
      end)
    end)
  end

  def get_adj_points({l, 0, 0}), do: [ {l-1, 1, 2}, {l-1, 2, 1}, {l, 1, 0}, {l, 0, 1} ]
  def get_adj_points({l, 0, 4}), do: [ {l-1, 3, 2}, {l-1, 2, 1}, {l, 1, 4}, {l, 0, 3} ]
  def get_adj_points({l, 4, 0}), do: [ {l-1, 2, 3}, {l-1, 1, 2}, {l, 4, 1}, {l, 3, 0} ]
  def get_adj_points({l, 4, 4}), do: [ {l-1, 2, 3}, {l-1, 3, 2}, {l, 4, 3}, {l, 3, 4} ]
  def get_adj_points({l, 2, 3}), do: [ {l-1, 2, 3}, {l-1, 3, 2}, {l, 4, 3}, {l, 3, 4} ]

  def get_adj_points({l, 1, 2}), do: [ {l, 0, 2}, {l, 1, 1}, {l, 1, 3}, {l+1, 0, 0}, {l+1, 0, 1}, {l+1, 0, 2}, {l+1, 0, 3}, {l+1, 0, 4} ]
  def get_adj_points({l, 2, 1}), do: [ {l, 2, 0}, {l, 1, 1}, {l, 3, 1}, {l+1, 0, 0}, {l+1, 1, 0}, {l+1, 2, 0}, {l+1, 3, 0}, {l+1, 4, 0} ]

  def get_adj_points({l, 2, 3}), do: [ {l, 2, 4}, {l, 1, 3}, {l, 3, 3}, {l+1, 0, 4}, {l+1, 1, 4}, {l+1, 2, 4}, {l+1, 3, 3}, {l+1, 3, 4} ]
  def get_adj_points({l, 3, 2}), do: [ {l, 3, 1}, {l, 4, 2}, {l, 3, 3}, {l+1, 4, 0}, {l+1, 4, 1}, {l+1, 4, 2}, {l+1, 4, 3}, {l+1, 3, 3} ]

  def get_adj_points({l, 0, y}), do: [ {l-1, 1, 2}, {l, 0, y+1}, {l, 0, y-1}, {l, 1, y} ]
  def get_adj_points({l, 4, y}), do: [ {l-1, 3, 2}, {l, 4, y+1}, {l, 4, y-1}, {l, 3, y} ]
  def get_adj_points({l, x, 0}), do: [ {l-1, 2, 1}, {l, x+1, 0}, {l, x-1, 0}, {l, x, 1} ]
  def get_adj_points({l, x, 4}), do: [ {l-1, 3, 2}, {l, x+1, 4}, {l, x-1, 4}, {l, x, 3} ]

  def get_adj_points({l, x, y}), do: [ {l, x-1, y}, {l, x+1, y}, {l, x, y-1}, {l, x, y+1} ]


  def next_state_point(p, ".", map) do
    cnt = get_adj_points(p) |> Enum.filter(&(Map.get(map, &1) == "#")) |> Enum.count()
    if cnt == 1 or cnt == 2, do: "#", else: "."
  end

  def next_state_point(p, "#", map) do
    cnt = get_adj_points(p) |> Enum.filter(&(Map.get(map, &1) == "#")) |> Enum.count()
    if cnt == 1, do: "#", else: "."
  end

  def next_state(map, t) do
    vals = for l <- -t..t, x <- 0..4, y <- 0..4, do: {l, x, y}

    vals |> Enum.filter(fn {_l, x, y} -> {x, y} != {2, 2} end) |> Enum.reduce(%{}, fn p, acc ->
      v = Map.get(map, p, ".")
      Map.put(acc, p, next_state_point(p, v, map))
    end)
  end

  def show_map(m, l) do

    for y <- 0..5 do
      for x <- 0..5 do

          IO.write(Map.get(m, {l, x, y}))

      end

      IO.write('\n')
    end
  end

  def looper(map, t, t), do: map
  def looper(map, times, idx) do
    looper(next_state(map, times), times, idx + 1 )
  end


  def part2_test() do
    test_input |> input_to_map
    |> looper(1, 0)

  end

  def part2() do
    #done = part1_loop(read_input |> input_to_map, MapSet.new)
    #done |> show_map
    #done |> part1_calc

  end

end
