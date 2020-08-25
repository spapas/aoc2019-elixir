defmodule Day7 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day7() do
    prog = read_program("day7.txt")
    # give 1 as input
    Intcode.runner(prog, 0)
  end


  def day57() do
    prog = read_program("day7.txt")
    # give 5 as input
    Intcode.runner(prog, 0)
  end
end
