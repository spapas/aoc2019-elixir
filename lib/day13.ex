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

  def play_game(progr, pc, paddlex, options ) do
    case runner(progr, pc, options) do
      {:block, new_progr, new_pc, new_options} ->
        output = Keyword.get(new_options, :output) |> IO.inspect |> Enum.reverse() |> Enum.chunk_every(3)
        score = output |> Enum.filter(fn [x,y, _v] -> {-1, 0} == {x, y} end)
        if Enum.count(score) > 0 do
          IO.puts("SCORE IS #{inspect(score)}")
        end
        ball = output |> Enum.filter(fn [_x, _y, v] -> v == 4 end) |> List.last()
        [ballx, _y, 4] = ball

        paddle = output |> Enum.filter(fn [_x, _y, v] -> v == 3 end) |> List.last()

        IO.puts("PADDLE IS ")
        px = case paddle do
          [new_paddlex, _y, 3] -> new_paddlex
          _ -> paddlex
        end |> IO.inspect

        IO.puts("~~~~")
        inp = cond do
          px > ballx -> -1
          px < ballx -> 1
          px == ballx -> 0
        end |> IO.inspect
        {px, ballx, inp} |> IO.inspect
        IO.puts("~~~~")

        play_game(new_progr, new_pc, paddlex + px, (new_options |> Keyword.delete(:output) |> Keyword.put(:input, [inp])))

      {output, _progr} -> output
    end
  end

  def day13b do
    progr = read_program("day13.txt") |> Map.put(0, 2)
    output = play_game(progr, 0, 0, input: [-1]) |> List.last


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
