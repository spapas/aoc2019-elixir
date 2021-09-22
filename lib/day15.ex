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
    {:block, progr1, pc1, [input: [], output: [output]]} = runner(progr, pc, input: [input])
    {progr1, pc1, output}
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
      pc: 0,
      steps: 0

    }
  end

  def get_pos_by_direction({x, y}, 1), do: {x, y-1}
  def get_pos_by_direction({x, y}, 2), do: {x, y+1}
  def get_pos_by_direction({x, y}, 3), do: {x-1, y}
  def get_pos_by_direction({x, y}, 4), do: {x+1, y}

  def get_next_states(%{pos: pos, progr: progr, pc: pc, steps: steps}) do
    Enum.map([1,2,3,4], fn dir -> {step(progr, pc, dir), dir} end)
    |> Enum.filter(fn {{_progr, _pc, output}, _dir} -> output > 0 end)
    |> Enum.map(fn {{progr1, pc1, output}, dir} -> %{
      pos: get_pos_by_direction(pos, dir),
      what: output,
      progr: progr1,
      pc: pc1,
      steps: steps+1
    } end)
  end

  def init_queue() do
    q = get_queue()
    push(q, get_initial_state())
  end

  def bfs(visited, queue, acc) do
    if empty?(queue) do
      acc
    else
      {curr, q} = pop(queue)
      if Map.get(curr, :pos) in visited do
        bfs(visited, q, acc)
      else
        visited1 = MapSet.put(visited, Map.get(curr, :pos))
        queue1 =  get_next_states(curr) |> Enum.reduce(q, &(push(&2, &1)))

        bfs(visited1, queue1, [curr | acc])
      end
    end
  end

  def map() do

    bfs(MapSet.new(), init_queue(), [])
  end

  def get_goal_pos(m) do
    m |> Enum.filter(fn %{what: what} -> what == 2 end) |> Enum.at(0) |> Map.get(:pos)
  end

  def print_spot({x, y}) do
    case {x, y} do
      {0, 0} -> '.'
      {12,12} -> 'x'
      _ -> ' '
    end
  end

  def show_map(m) do
    walks = MapSet.new( Enum.map(m, fn %{pos: pos} -> pos end ))
    for y <- -22..22 do
      for x <- -22..22 do
        IO.write(
          if {x, y} in walks, do: print_spot({x, y}), else: '#'
        )
      end

      IO.write('\n')
    end
  end

  def part1() do
    map() |> Enum.filter(fn %{what: what} -> what == 2 end) |> Enum.at(0) |> Map.get(:steps)
  end

  def part2a() do
    map() |> Enum.max_by(fn %{steps: steps} -> steps end)
  end
  def part2() do
    m = map()
    timer = 0
    pos_oxygen = [{0, 0}]
    tot_pos = Enum.map(m, &Map.get(&1, :pos)) |> Enum.filter(fn pos -> pos != {0, 0} end ) |> MapSet.new
    #tot_pos = [
    #  {-1, 0}, {1, 0}, {-1, -1}, {1, -1}, {0, -2}, {-1, -2}, {2, -1}
    #] |> MapSet.new

    fill_oxygen(pos_oxygen, tot_pos, timer)
  end

  def fix_po_tp({x, y}, {pos_oxygen, tot_pos}) do
    p1 = {x + 1, y}
    p2 = {x - 1, y}
    p3 = {x, y + 1}
    p4 = {x, y - 1}

    Enum.reduce([p1, p2, p3, p4], {pos_oxygen, tot_pos}, fn p, {po, tp} ->
      if p in tp do
        po1 = [p | po]
        tp1 = MapSet.delete(tp, p)
        {po1, tp1}
      else
        {po, tp}
      end
    end)

  end

  def fill_oxygen(pos_oxygen, tot_pos, timer) do
    {timer, Enum.count(pos_oxygen), Enum.count(tot_pos)} |> IO.inspect
    pos_oxygen |> IO.inspect
    tot_pos |> IO.inspect
    if Enum.empty?(tot_pos) or timer > 1000 do
      timer
    else
      {pos_oxygen1, tot_pos1} = Enum.reduce(pos_oxygen, {pos_oxygen, tot_pos}, &fix_po_tp/2)
      fill_oxygen(pos_oxygen1, tot_pos1, timer+1)
    end
  end

end
