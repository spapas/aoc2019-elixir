defmodule Day2 do
  def runner(progr, pc) do
    op = progr |> Enum.at(pc)

    case op do
      99 ->
        progr

      1 ->
        p1 = Enum.at(progr, pc + 1)
        p2 = Enum.at(progr, pc + 2)
        p3 = Enum.at(progr, pc + 3)
        new_progr = progr |> List.replace_at(p3, Enum.at(progr, p1) + Enum.at(progr, p2))
        runner(new_progr, pc + 4)

      2 ->
        p1 = Enum.at(progr, pc + 1)
        p2 = Enum.at(progr, pc + 2)
        p3 = Enum.at(progr, pc + 3)
        new_progr = progr |> List.replace_at(p3, Enum.at(progr, p1) * Enum.at(progr, p2))
        runner(new_progr, pc + 4)
    end
  end

  def day2 do
    prog = File.read!("day2.txt") |> String.split(",") |> Enum.map(&String.to_integer/1)
    new_prog = prog |> List.replace_at(1, 12) |> List.replace_at(2, 2)
    runner(new_prog, 0) |> hd
  end

  def day2b do
    prog = File.read!("day2.txt") |> String.split(",") |> Enum.map(&String.to_integer/1)
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
