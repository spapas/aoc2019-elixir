defmodule Day5 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day5() do
    prog = read_program("day5.txt")
    # give 1 as input
    {out, _prog} = Intcode.runner(prog, 0, input: [1])
    out |> List.last

  end


  def day5b() do
    prog = read_program("day5.txt")
    # give 5 as input
    {out, _prog} = Intcode.runner(prog, 0, input: [5])
    out |> List.last
  end
end
