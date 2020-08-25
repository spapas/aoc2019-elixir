defmodule Day7 do
  import Intcode, only: [runner: 2, read_program: 1]

  def day7() do
    prog = read_program("day7.txt")
    # give 1 as input
    Intcode.runner(prog, 0)
  end


  def day7() do
    prog = read_program("day7.txt")
    Intcode.runner(prog, 0)
  end


  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list--[elem]) do
      [elem|rest]
    end
  end
end
