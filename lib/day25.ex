defmodule Day25 do
  import Intcode, only: [runner: 3, read_program: 1]
  @items [
    "boulder", "asterisk", "mutex", "candy cane",
    "food ration", "prime number", "mug", "loom"
  ]
  @walkthrough [
    'south\n',
    'take boulder\n',
    'east\n',
    'take food ration\n',
    'west\n',
    'west\n',
    'take asterisk\n',
    'east\n',
    'north\n',
    'inv\n',
    'east\n',
    'take candy cane\n',
    'north\n',
    'north\n',
    'take mutex\n',
    'north\n',
    'take prime number\n',
    'south\n',
    'south\n',
    'east\n',
    'north\n',
    'take mug\n',
    'south\n',
    'west\n',
    'south\n',
    'east\n',
    'north\n',
    'take loom\n',
    'south\n',
    'east\n',
    'south\n',
    'east\n',
    'east\n',
    'inv\n',
    'drop loom\n',
    'drop mug\n',
    'drop prime number\n',
    'drop mutex\n',
    'drop candy cane\n',
    'drop asterisk\n',
    'drop food ration\n',
    'drop boulder\n',
    'inv\n'
  ]

  def get_progr do
    read_program("day25.txt")
  end

  def play_step(progr, pc, options) do
    Keyword.get(options, :output) |> Enum.reverse |> IO.puts
    options = Keyword.put(options, :output, []) |> IO.inspect
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

  def get_walkthrough(), do: @walkthrough
  def get_items(), do: @items

  def play_command(cmd, {progr1, pc1, options1}) do
    options1 = Keyword.put(options1, :input, cmd)
    {:block, progr1, pc1, options1} = runner(progr1, pc1, options1)
    Keyword.get(options1, :output) |> Enum.reverse |> IO.puts
    {progr1, pc1, options1}
  end

  def try_items(progr, pc, options, n) do
    IO.inspect("TRY TRY")
    item_combinations = combination(n, get_items)
    Enum.map(item_combinations, fn items ->
      IO.inspect("KKK")
      commands = Enum.map(items, fn item -> String.to_charlist("take " <> item <> "\n") end) ++ ['inv\n', 'north\n']
      commands |> IO.inspect
      Enum.reduce(commands, {progr, pc, options}, &play_command/2)
    end)
  end


  def playback() do
    progr = get_progr
    pc = 0
    options = [input: []]
    {:block, progr, pc, options} = runner(progr, pc, options)
    {progr, pc, options } = Enum.reduce(get_walkthrough(), {progr, pc, options}, &play_command/2)

    # Have dropped items now
    # 8 items ain't working

    IO.inspect("Try with 4 items")

    try_items(progr, pc, Keyword.put(options, :output, []), 4)
    |> Enum.map(fn {progr, pc, options} -> Keyword.get(options, :output)
    |> Enum.reverse end)
    |> Enum.filter( &(not String.contains?(to_string(&1), "Alert! Droids" )))

    {progr, pc, options }

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
