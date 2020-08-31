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
    case runner(progr, pc, input: [Map.get(grid, location, 0)]) do
      {:block, new_progr, new_pc, options} ->
        # Careful output may be reversed
        [turn, color] = Keyword.get(options, :output)

        painter(
          Map.put(grid, location, color),
          new_progr,
          new_pc,
          update_location({location, face}, turn)
        )

      {output, _progr} ->
        [color, _turn] = output
        Map.put(grid, location, color)
    end
  end

  def day11 do
    progr = read_program("day11.txt")
    grid = Map.new()

    res = painter(grid, progr, 0, {{0, 0}, :up})


  end

  def display(grid) do
    for y <- -40..40 do
      for x <- -40..100 do
        IO.write(
          case Map.get(grid, {x, y}) do
            0 -> "_"
            1 -> "#"
            _ -> '.'
          end
        )
      end

      IO.write('\n')
    end
  end

  def day11 do
    progr = read_program("day11.txt")
    grid = Map.new() |> Map.put({0,0}, 1)

    res = painter(grid, progr, 0, {{0, 0}, :up})

  end
end
