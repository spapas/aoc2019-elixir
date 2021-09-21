defmodule Day15 do
  import Intcode, only: [runner: 3, read_program: 1]

  def day15 do
    new_prog = read_program("day15.txt")
    runner(new_prog, 0, input: [1])

  end



end
