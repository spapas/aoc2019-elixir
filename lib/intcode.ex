defmodule Intcode do

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

  def read_program(input) do
    File.read!(input) |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
