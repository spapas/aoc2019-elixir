defmodule Day19 do

  import Intcode, only: [runner: 3, read_program: 1]


  def get_progr do
    read_program("day19.txt")

  end

  def get_output_for_point({x, y}) do
    {[out|t], progr} = runner(get_progr(), 0, input: [x, y])

    out
  end

  def get_grid_for_size(mx, my) do
    for x <- 0..mx, y <- 0..my do
      {{x,y}, get_output_for_point({x,y})}
    end
  end

  def part1() do
    get_grid_for_size(49, 49) |> Enum.filter(fn {p, v} -> v == 1 end) |> Enum.count
  end

  def show_map() do
    g = get_grid_for_size(200, 200) |> Map.new
    for y <- 0..1000 do
      for x <- 0..1000 do
        IO.write(
          if Map.get(g, {x, y}) == 1, do: '#', else: ' '
        )
      end

      IO.write('\n')
    end
  end

  def find_square_in_beam( x, y) do
    {x, y}
    width = get_output_for_point({x + 99, y})
    height = get_output_for_point({x , y+ 99})

    case {width, height}
      {1, 1} -> {x, y}
      {1, 0} -> find_square_in_beam( x + 1, y)
      _ -> find_square_in_beam( x, y + 1)
    end
  end

  def part2() do
    {x, y} = find_square_in_beam(0, 0)
    x * 10000 + y
  end


end
