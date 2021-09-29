defmodule Day25 do
  import Intcode, only: [runner: 3, read_program: 1]

  def get_progr do
    read_program("day25.txt")
  end

  def play_loop(progr, pc, options) do
    case runner(progr, pc, options) do
      {:block, progr, pc, options} ->
        Keyword.get(options, :output) |> Enum.reverse |> IO.puts
        input = IO.gets("> ") |> String.to_charlist

        if input == 'qq\n' do
          "EXIT"
        else
          options = Keyword.put(options, :input, input)

          play_loop(progr, pc , options)
        end
      v ->
        IO.puts(elem(v, 0))
        IO.puts("TRY AGAIN")
      input = IO.gets("> ") |> String.to_charlist

        if input == 'qq\n' do
          "EXIT"
        else
          options = Keyword.put(options, :input, input)

          play_loop(progr, pc , options)
        end
    end
  end

  def play() do
    progr = get_progr
    pc = 0
    options = [input: []]
    play_loop(progr, pc, options)
  end




end
