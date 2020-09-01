defmodule Day13 do
  import Intcode, only: [runner: 3, read_program: 1]
  @mx 21
  @my 25

  def get_maxx(), do: @mx
  def get_maxy(), do: @my

  def day13 do
    new_prog = read_program("day13.txt")
    { output, _p } = runner(new_prog, 0, input: [])
    output |> Enum.chunk_every(3) |> Enum.filter(fn [_a, _b, c] -> c == 2 end) |> Enum.count
  end

  def day13b do
    progr = read_program("day13.txt") |> Map.put(0, 2)
    {:block, progr, pc, options} = runner(progr, 0, input: [])
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

    new_options = options|>Keyword.delete(:output)|>Keyword.put(:input, [-1])
    {:block, progr, pc, options } = runner(progr, pc, new_options)
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

    new_options = options|>Keyword.delete(:output)|>Keyword.put(:input, [1])
    {:block, progr, pc, options } = runner(progr, pc, new_options)
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

    new_options = options|>Keyword.delete(:output)|>Keyword.put(:input, [1])
    {:block, progr, pc, options } = runner(progr, pc, new_options)
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

    new_options = options|>Keyword.delete(:output)|>Keyword.put(:input, [1])
    {:block, progr, pc, options } = runner(progr, pc, new_options)
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

    new_options = options|>Keyword.delete(:output)|>Keyword.put(:input, [1])
    {:block, progr, pc, options } = runner(progr, pc, new_options)
    Keyword.get(options, :output) |> Enum.reverse() |> Enum.chunk_every(3) |> Enum.map(fn [x, y, v] -> {{x, y}, v} end ) |> Map.new |> display()

  end

  def display(grid) do

    for y <- 0..get_maxy()+1 do
      for x <- 0..get_maxx()+1 do
        IO.write(
          case Map.get(grid, {x, y}) do
            0 -> " "
            1 -> "|"
            2 -> "#"
            3 -> "_"
            4 -> "."
            v -> v
          end
        )
      end

      IO.write('\n')
    end
    # {xmax, xmin, ymax, ymin}
  end


end
