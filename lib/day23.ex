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

  def remove_255(q) do
    :queue.filter( fn [addr, x, y] -> addr != 255 end, q)
  end



  def init_queue(network,queue, nat ) do


    0..49 |> Enum.reduce({network, queue, nat}, fn addr, {n, q, nat} -> send_packet(addr, [-1], n, q, nat) end)

  end



  def send_packet(idx, data, network, q, nat) do
    {progr, pc, options} = Map.get(network, idx)
    {:block, progr, pc, options} = runner(progr, pc, Keyword.put(options, :input, data))
    network = Map.put(network, idx, {progr, pc, options})
    output = Keyword.get(options, :output, [])
    chunked_output = output |> Enum.reverse |> Enum.chunk_every(3)
    nat = case Enum.filter(Enum.reverse(chunked_output), fn [a, x, y] -> a == 255 end) do
      [] -> nat
      [h|_t] -> h
    end
    q = chunked_output |> Enum.filter(fn [a, x, y] -> a != 255 end) |> Enum.reduce(q, fn (el, q) -> push(q, el) end )
    {network, q, nat}
  end

  def step(network, queue, nat ) do
    if empty?(queue) do
      nat |> IO.inspect

      send_packet(0, nat, network, queue, nil)

    else
      {curr, q} = pop(queue)
      case curr do
        [255, x, y] -> 55
        [idx, -1] -> send_packet(idx, [-1], network, q, nat)
        [idx, x, y] -> send_packet(idx, [x,y], network, q, nat)
      end
    end
  end

  def runme(network, queue, nat) do
    case step(network, queue, nat) do
      {network, queue, nat} -> runme(network, queue, nat)
      data -> data
    end
  end

  def part2() do
    network = get_network()
    {network, queue, nat} = init_queue(network, get_queue, nil)

    runme(network, queue, nat)
  end

end
