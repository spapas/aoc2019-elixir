defmodule Day25 do
  import Intcode, only: [runner: 3, read_program: 1]
  @items [
    "boulder", "asterisk", "mutex", "candy cane",
    "food ration", "prime number",
  ]

  def get_progr do
    read_program("day25.txt")
  end

  def play_step(progr, pc, options) do
    Keyword.get(options, :output) |> Enum.reverse |> IO.puts
    options = Keyword.put(options, :output, [])

    input = IO.gets("> ") |> String.to_charlist

    case input do
      'qq\n' ->
        "EXIT"
        {progr, pc, options}
      'n\n' -> play_loop(progr, pc , Keyword.put(options, :input, 'north\n') )
      's\n' -> play_loop(progr, pc , Keyword.put(options, :input, 'south\n') )
      'e\n' -> play_loop(progr, pc , Keyword.put(options, :input, 'east\n') )
      'w\n' -> play_loop(progr, pc , Keyword.put(options, :input, 'west\n') )

        v -> play_loop(progr, pc , Keyword.put(options, :input, input) )
    end
  end

  def play_loop(progr, pc, options) do
    case runner(progr, pc, options) do
      {:block, progr, pc, options} ->
        play_step(progr, pc, options)
        v ->
          IO.puts(elem(v, 0))
          IO.puts("TRY AGAIN")
          play_step(progr, pc, options)
    end
  end

  def play() do
    progr = get_progr
    pc = 0
    options = [input: []]
    play_loop(progr, pc, options)
  end


  def playback() do
    progr = get_progr
    pc = 0
    options = [input: []]
    play_loop(progr, pc, options)
  end


  def resume(progr, pc, options) do
    play_loop(progr, pc, options)
  end


  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
    (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end


end
