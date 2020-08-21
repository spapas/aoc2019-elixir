defmodule Intcode do

  def runner(progr, pc) do
    op = progr |> Map.get(pc)

    case op do
      99 ->
        progr

      1 ->
        p1 = Map.get(progr, pc + 1)
        p2 = Map.get(progr, pc + 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, Map.get(progr, p1) + Map.get(progr, p2))
        runner(new_progr, pc + 4)

      2 ->
        p1 = Map.get(progr, pc + 1)
        p2 = Map.get(progr, pc + 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, Map.get(progr, p1) * Map.get(progr, p2))
        runner(new_progr, pc + 4)
    end
  end

  def read_program(input) do
    File.read!(input)
    |> String.split(",")
    |> Enum.with_index
    |> Enum.map(fn {f,s} -> {s, String.to_integer(f)} end)
    |> Map.new
  end
end
