defmodule Day7 do
  import Intcode, only: [read_program: 1]

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
    perms |> Enum.map(&(amp(&1, prog))) |> Enum.max
  end

  def amp2(phase, prog) do
    get_initial_state(phase, prog) |> do_amp2(0)
  end

  def get_initial_state(phase, prog) do
    phase |> Enum.with_index |> Enum.map(&%{
      pc: 0,
      prog: prog,
      options: [
        input: (if elem(&1,1) == 0, do: [elem(&1, 0), 0], else: [elem(&1, 0)]),
        output: []
      ]
    })
  end

  def update_state(state, amp_no, next_amp_no, new_prog, new_pc, new_options) do
    state
    |> List.update_at(amp_no, fn _s ->
      %{pc: new_pc, prog: new_prog, options: new_options |> Keyword.update!(:output, fn _o ->
        []
      end )}
    end)
    |> List.update_at(next_amp_no, fn s ->
      s |> update_in([:options, :input], &( &1 ++ [List.first(Keyword.get(new_options, :output))] ))
    end)

  end

  def do_amp2(state, amp_no) do
    %{pc: pc, prog: prog, options: options} = state |> Enum.at(amp_no)
    IO.inspect("Starting #{amp_no} with runner opts: #{options|>inspect}")
    case Intcode.runner(prog, pc, options) do
      {:block, new_prog, new_pc, new_options}  ->

        next_amp_no = if amp_no < 4, do: amp_no+1, else: 0
        IO.puts("NAN: #{next_amp_no}")
        new_state = update_state(state, amp_no, next_amp_no, new_prog, new_pc, new_options)
        do_amp2(new_state, next_amp_no)
      {output, _progr} -> if amp_no == 4 do
        output
      else
        IO.puts("LAST RUN NAN: #{amp_no+1}")
        new_state = state |> List.update_at(amp_no+1, fn s ->
          s |> update_in([:options, :input], &( &1 ++ [List.first(output)] ))
        end)
        do_amp2(new_state, amp_no+1)
      end
    end
  end

  def day7b() do
    prog = read_program("day7.txt")
    perms = permutations([5,6,7,8,9])
    perms |> Enum.map(&(amp2(&1, prog))) |> Enum.max
  end

  def day7btest() do
    prog = Intcode.intlist_to_program([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5])
    amp2([9,8,7,6,5], prog)
  end

end
