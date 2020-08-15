defmodule Day3 do

  def get_wire_points_reducer("U"<>rest, acc) do
    create_wire_points_int(0, 1, rest, acc)
  end

  def get_wire_points_reducer("D"<>rest, acc) do
    create_wire_points_int(0, -1, rest, acc)
  end

  def get_wire_points_reducer("L"<>rest, acc) do
    create_wire_points_int(-1, 0, rest, acc)
  end

  def get_wire_points_reducer("R"<>rest, acc) do
    create_wire_points_int(1, 0, rest, acc)
  end

  def create_wire_points_int(dx, dy, rest, {{x, y}, l}) do
    n = rest |> String.to_integer
    r = for i <- 1..n do
      {x + dx*i, y + dy*i}
    end
    {List.last(r), l++r}
  end

  def get_wire_points(w) do
    w |> String.split(",") |> Enum.reduce({{0,0}, []}, &get_wire_points_reducer/2)
  end

  def manhattan({x,y}), do: abs(x) + abs(y)
  def day3 do
    [w1, w2, _] = File.read!("day3.txt") |> String.split("\n")
    {_p, points1} = w1 |> get_wire_points()
    {_p, points2} = w2 |> get_wire_points()
    MapSet.intersection(points1|>MapSet.new, points2|>MapSet.new)
    |> Enum.min_by(&manhattan/1) |> manhattan
  end

end
