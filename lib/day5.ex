defmodule Day5 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day5() do
    prog = read_program("day5.txt")
    # give 1 as input
    Intcode.runner(prog, 0)
  end


  def day5b() do
    prog = read_program("day5.txt")
    # give 5 as input
    Intcode.runner(prog, 0)
  end
end
