defmodule Day15 do
  @n 1
  @s 2
  @w 3
  @e 4

  import Intcode, only: [runner: 3, read_program: 1]

  def get_progr do
    read_program("day15.txt")
    # {:block, progr, pc, options} = runner(new_prog, 0, input: [1])

  end

  def step(progr, pc, input) do
    {:block, progr, pc, [input: [], output: [output]]} = runner(progr, pc, input: [input])
    {progr, pc, output}
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

  def get_initial_state() do
    %{
      pos: {0, 0},
      what: 1,
      progr: get_progr(),
      pc: 0
    }
  end

  def get_pos_by_direction({x, y}, 1), do: {x, y-1}
  def get_pos_by_direction({x, y}, 2), do: {x, y+1}
  def get_pos_by_direction({x, y}, 3), do: {x-1, y}
  def get_pos_by_direction({x, y}, 4), do: {x+1, y}

  def get_next_states(%{pos: pos, progr: progr, pc: pc}) do
    Enum.map([1,2,3,4], fn dir -> {step(progr, pc, dir), dir} end)
    |> Enum.filter(fn {{_progr, _pc, output}, _dir} -> output > 0 end)
    |> Enum.map(fn {{progr, pc, output}, dir} -> %{
      pos: get_pos_by_direction(pos, dir),
      what: output,
      progr: progr,
      pc: pc
    } end)
  end

  def init_queue() do
    q = get_queue()
    push(q, get_initial_state())
  end

  def bfs(visited, queue, minput, acc) do
    if empty?(queue) do
      acc
    else
      {curr, q} = pop(queue)
      if curr in visited do
        bfs(visited, q, minput, acc)
      else
        curr |> Enum.count() # |> IO.inspect()
        a2 = if curr |> Enum.count() == 1 do
          [curr | acc]
        else
          acc
        end
        v2 = visited |> MapSet.put(curr)
        q2 = curr ##|> IO.inspect()
        |> get_next_states() #|> IO.inspect()
        |> Enum.reduce(q, &(push(&2, &1)))
        bfs(v2, q2, minput, a2)
      end
    end
  end


end
