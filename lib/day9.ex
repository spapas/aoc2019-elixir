defmodule Day9 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day9 do
    new_prog = read_program("day9.txt")
    runner(new_prog, 0)
  end

  def day2b do

  end
end
