defmodule Day7 do
  import Intcode, only: [runner: 2, read_program: 1]



  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list--[elem]) do
      [elem|rest]
    end
  end



  def amp(phase, prog) do
    amp_reducer = fn acc, el ->
      {output, _prog} = Intcode.runner(prog, 0, input: [acc, el])
      output |> List.last
    end
    phase |> Enum.reduce(0, amp_reducer)
  end

  def day7() do
    prog = read_program("day7.txt")
    perms = permutations([0,1,2,3,4])
    perms |> Enum.reverse |> Enum.map(&(amp(&1, prog))) |> Enum.max
  end




  def day7b() do
    1
  end

end
