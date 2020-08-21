defmodule Day2 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day2 do
    new_prog = read_program("day2.txt") |> Map.put(1, 12) |> Map.put(2, 2)
    runner(new_prog, 0) |> Map.get(0)
  end

  def day2b do
    prog = read_program("day2.txt")
    pairs = for a <- 1..99, b <- 1..99, do: [a, b]

    [[_h, [a, b]]] =
      Enum.map(pairs, fn [a, b] = p ->
        new_prog = prog |> Map.put(1, a) |> Map.put(2, b)
        [runner(new_prog, 0) |> Map.get(0), p]
      end)
      |> Enum.filter(&(&1 |> hd == 19_690_720))

    a * 100 + b
  end
end
