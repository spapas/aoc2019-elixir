defmodule Day2 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day2 do
    new_prog = read_program("day2.txt") |> List.replace_at(1, 12) |> List.replace_at(2, 2)
    runner(new_prog, 0) |> hd
  end

  def day2b do
    prog = read_program("day2.txt")
    pairs = for a <- 1..99, b <- 1..99, do: [a, b]

    [[_h, [a, b]]] =
      Enum.map(pairs, fn [a, b] = p ->
        new_prog = prog |> List.replace_at(1, a) |> List.replace_at(2, b)
        [runner(new_prog, 0) |> hd, p]
      end)
      |> Enum.filter(&(&1 |> hd == 19_690_720))

    a * 100 + b
  end
end
