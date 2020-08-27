defmodule Day9 do
  import Intcode, only: [runner: 3, read_program: 1]

  def day9 do
    new_prog = read_program("day9.txt")
    runner(new_prog, 0, input: [1])
  end

  def day9b do
    new_prog = read_program("day9.txt")
    runner(new_prog, 0, input: [2])
  end
end
