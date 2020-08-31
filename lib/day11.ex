defmodule Day11 do
  import Intcode, only: [runner: 3, read_program: 1]

  def update_location({{x, y}, :up}, 0), do: {{x - 1, y}, :left}
  def update_location({{x, y}, :right}, 0), do: {{x, y - 1}, :up}
  def update_location({{x, y}, :down}, 0), do: {{x + 1, y}, :right}
  def update_location({{x, y}, :left}, 0), do: {{x, y + 1}, :down}

  def update_location({{x, y}, :up}, 1), do: {{x + 1, y}, :right}
  def update_location({{x, y}, :right}, 1), do: {{x, y + 1}, :down}
  def update_location({{x, y}, :down}, 1), do: {{x - 1, y}, :left}
  def update_location({{x, y}, :left}, 1), do: {{x, y - 1}, :up}

  def painter(grid, progr, pc, {location, face}) do
    case runner(progr, pc, input: [Map.get(grid, location)]) do
      {:block, new_progr, new_pc, options} ->
        # Careful output may be reversed
        [turn, color] = Keyword.get(options, :output)

        painter(
          Map.put(grid, location, color),
          new_progr,
          new_pc,
          update_location({location, face}, turn)
        )

      {[color, _turn], _progr} ->
        Map.put(grid, location, color)
    end
  end

  def day11 do
    progr = read_program("day11.txt")
    grid = Map.new()

    painter(grid, progr, 0, {{0, 0}, :up}) #|> Map.keys() |> Enum.count()


  end

  def display(grid) do
    {{xmax, _y}, _v} = grid |> Enum.max_by(fn {{x,_y}, _v} -> x end)
    {{xmin, _y}, _v} = grid |> Enum.min_by(fn {{x,_y}, _v} -> x end)
    {{_x, ymax}, _v} = grid |> Enum.max_by(fn {{_x,y}, _v} -> y end)
    {{_x, ymin}, _v} = grid |> Enum.min_by(fn {{_x,y}, _v} -> y end)
    for y <- ymax..ymin do
      for x <- xmax..xmin do
        IO.write(
          case Map.get(grid, {x, y}) do
            0 -> " "
            1 -> "#"
            _ -> " "
          end
        )
      end

      IO.write('\n')
    end
    {xmax, xmin, ymax, ymin}
  end

  def day11b do
    progr = read_program("day11.txt")
    grid = Map.new() |> Map.put({50,50}, 1)

    painter(grid, progr, 0, {{50, 50}, :up})

  end
end
