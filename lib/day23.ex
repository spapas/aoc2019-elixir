defmodule Day23 do
  import Intcode, only: [runner: 3, read_program: 1]

  def get_progr do
    read_program("day23.txt")
  end

  def boot(progr, address) do
    {:block, progr, pc, options} = runner(progr, 0, input: [])
    {:block, progr, pc, options} = runner(progr, pc, Keyword.put(options, :input, [address]))

    {address, {progr, pc, options}}
  end

  def get_network() do
    0..49 |> Enum.map(fn x -> boot(get_progr, x) end ) |> Map.new
  end

  def get_queue() do
    :queue.new
  end

  def push(q, v) do
    :queue.in(v, q)
  end

  def pop(q) do
    {{:value, v}, q} = :queue.out(q)
    {v, q}
  end

  def empty?(q) do
    :queue.is_empty(q)
  end


  def init_queue(network) do
    queue = get_queue()

    0..49 |> Enum.reduce({network, queue}, fn addr, {n, q} -> send_packet(addr, [-1], n, q) end)

  end



  def send_packet(idx, data, network, q) do
    {progr, pc, options} = Map.get(network, idx)
    {:block, progr, pc, options} = runner(progr, pc, Keyword.put(options, :input, data))
    network = Map.put(network, idx, {progr, pc, options})
    output = Keyword.get(options, :output, [])
    q = output |> Enum.reverse |> Enum.chunk_every(3) |> Enum.reduce(q, fn (el, q) -> push(q, el) end )
    {network, q}
  end

  def step(network, queue) do
    {curr, q} = pop(queue) |> IO.inspect
    case curr do
      [255, data] -> data |> IO.inspect
      [idx, -1] -> send_packet(idx, [-1], network, q)
      [idx, x, y] -> send_packet(idx, [x,y], network, q)
    end
  end

  def runme(network, queue) do
    case step(network, queue) do
      {network, queue} -> runme(network, queue)
      data -> data
    end
  end

  def part1() do
    network = get_network()
    {network, queue} = init_queue(network)
    runme(network, queue)
  end

end
