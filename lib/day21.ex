defmodule Day21 do


  import Intcode, only: [runner: 3, read_program: 1]

  def get_progr do
    read_program("day21.txt")

  end

  def step(progr, pc, rbase, input) do
    case runner(progr, pc, input: input, rbase: rbase) do
      {:block, progr1, pc1, [input: [], rbase: rbase, output: output]} ->
        IO.puts(output |> Enum.reverse)
        {progr1, pc1, rbase, output}
      {:block, progr1, pc1, [input: [], rbase: rbase]} ->
        IO.puts("OK!!")
        {progr1, pc1, rbase}
      v -> v

    end
  end

  def part1() do
    progr = get_progr()
    pc = 0
    rbase = 0
    {progr, pc, rbase, _output} = step(progr, pc, rbase, [])
    IO.puts("A")
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT A T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT T T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND B T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND C T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT T J\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND D J\n')

    IO.puts("B")
    {output, progr} = step(progr, pc, rbase, 'WALK\n')
    IO.puts(output)

  end


  def part2() do
    progr = get_progr()
    pc = 0
    rbase = 0
    {progr, pc, rbase, _output} = step(progr, pc, rbase, [])
    IO.puts("A")
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT A T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT T T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND B T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND C T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT T J\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND D J\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT H T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'NOT T T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'OR E T\n')
    {progr, pc, rbase} = step(progr, pc, rbase, 'AND T J\n')

    IO.puts("B")
    {output, progr} = step(progr, pc, rbase, 'RUN\n')
    IO.puts(output)

  end




end
