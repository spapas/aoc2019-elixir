defmodule Day13 do
  import Intcode, only: [runner: 3, read_program: 1]

  def day13 do
    new_prog = read_program("day13.txt")
    runner(new_prog, 0, input: [])
  end

  def day13b do
    #new_pro13 = read_program("day9.txt")
    #runner(new_prog, 0, input: [2])
  end
end
