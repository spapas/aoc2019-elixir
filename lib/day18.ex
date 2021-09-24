defmodule Day18 do
  alias PriorityQueue, as: PQ


  def read_input() do
    File.read!("day18.txt")
  end


  def read_input2() do
    File.read!("day18b.txt")
  end

  def test_input() do
"#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################"
  end

  def test_input2() do
"#############
#g#f.D#..h#l#
#F###e#E###.#
#dCba@#@BcIJ#
#############
#nK.L@#@G...#
#M###N#H###.#
#o#m..#i#jk.#
#############"
  end

  def input_to_map(input) do
    input |> String.split(["\r\n", "\n"]) |> Enum.map( &String.graphemes/1) |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        Map.put(accx, {x, y}, v)
      end)
    end)
  end

  def map(), do: input_to_map(read_input())

  def get_start(mm) do
    [{start, _v}] = Enum.filter(mm, fn {_k, v} -> v=="@" end)
    start
  end

  def get_start2(mm) do
    mm |> Enum.filter(fn {_k, v} -> v=="@" end) |> Enum.map(fn {p, _v} -> p end) |> List.to_tuple

  end

  def get_initial_state(mm) do
    pos = get_start(mm)
    %{
      pos: pos,
      steps: 0,
      keys: MapSet.new()
    }
  end

  def get_initial_state2(mm) do
    pos = get_start2(mm)
    %{
      pos: pos,
      steps: 0,
      keys: MapSet.new(),
      key_number: 0
    }
  end

  def get_next_state(%{pos: {x, y}, steps: steps, keys: keys}, mm) do
    case Map.get(mm, {x, y}) do
      v when v in [".", "@"] -> %{pos: {x, y}, steps: steps + 1, keys: keys}
      v when v >= "a" and v <= "z" -> %{pos: {x, y}, steps: steps + 1, keys: MapSet.put(keys, v)}
      v when v >= "A" and v <= "Z" -> if String.downcase(v) in keys do
          %{pos: {x, y}, steps: steps + 1, keys: keys}
        else
          nil
        end
      _ -> nil
    end
  end

  def get_next_states(%{pos: {x, y}, steps: steps, keys: keys}, mm) do
    p1 = {x - 1, y}
    p2 = {x + 1, y}
    p3 = {x, y - 1}
    p4 = {x, y + 1}
    [p1, p2, p3, p4]
    |> Enum.map(fn p ->
      get_next_state(%{ pos: p, steps: steps, keys: keys }, mm)
    end)
    |> Enum.filter(fn s -> s != nil end)
  end

  def get_next_state2a(%{pos: {x, y}, steps: steps, keys: keys, key_number: key_number}, mm) do
    case Map.get(mm, {x, y}) do
      v when v in [".", "@"] -> %{pos: {x, y}, steps: steps + 1, keys: keys, key_number: key_number}
      v when v >= "a" and v <= "z" -> if v in keys do
        %{pos: {x, y}, steps: steps + 1, keys: keys, key_number: key_number}
      else
        %{pos: {x, y}, steps: steps + 1, keys: MapSet.put(keys, v), key_number: key_number+1}
      end
      v when v >= "A" and v <= "Z" -> if String.downcase(v) in keys do
          %{pos: {x, y}, steps: steps + 1, keys: keys, key_number: key_number}
        else
          nil
        end
      _ -> nil
    end
  end

  def get_next_state2b(%{pos: {x, y}, steps: steps, keys: keys, key_number: key_number}, visited, mm) do
    p1 = {x - 1, y}
    p2 = {x + 1, y}
    p3 = {x, y - 1}
    p4 = {x, y + 1}
    [p1, p2, p3, p4]
    |> Enum.map(fn p ->
      get_next_state2a(%{ pos: p, steps: steps, keys: keys, key_number: key_number }, mm)
    end)
    |> Enum.filter(fn s ->
      s != nil and {Map.get(s, :pos), Map.get(s, :keys)} not in visited
    end)
  end

  def get_next_states2(%{pos: {{x1, y1}=p1, {x2, y2}=p2, {x3, y3}=p3, {x4, y4}=p4}, steps: steps, keys: keys, key_number: key_number}, visited, mm) do
    #combinations = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    #Enum.map(combinations, fn {dx, dy} ->

      l1 = get_next_state2b(%{pos: {x1, y1}, steps: steps, keys: keys, key_number: key_number}, visited, mm)
      |> Enum.map( fn %{pos: new_pos1, steps: new_steps, keys: new_keys, key_number: new_key_number} ->
        %{pos: {new_pos1, p2, p3, p4}, steps: new_steps, keys: new_keys, key_number: new_key_number}
      end)

      l2 = get_next_state2b(%{pos: {x2, y2}, steps: steps, keys: keys, key_number: key_number}, visited, mm)
      |> Enum.map( fn %{pos: new_pos2, steps: new_steps, keys: new_keys, key_number: new_key_number} ->
        %{pos: {p1, new_pos2, p3, p4}, steps: new_steps, keys: new_keys, key_number: new_key_number}
      end)

      l3 = get_next_state2b(%{pos: {x3, y3}, steps: steps, keys: keys, key_number: key_number}, visited, mm)
      |> Enum.map(fn %{pos: new_pos3, steps: new_steps, keys: new_keys, key_number: new_key_number} ->
        %{pos: {p1, p2, new_pos3, p4}, steps: new_steps, keys: new_keys, key_number: new_key_number}
      end)

      l4 = get_next_state2b(%{pos: {x4, y4}, steps: steps, keys: keys, key_number: key_number}, visited, mm)
      |> Enum.map(fn %{pos: new_pos4, steps: new_steps, keys: new_keys, key_number: new_key_number} ->
        %{pos: {p1, p2, p3, new_pos4}, steps: new_steps, keys: new_keys, key_number: new_key_number}
      end)

      #Enum.reduce([l1, l2, l3, l4], [], fn el, acc ->
      #  Enum.reduce(el, acc, fn el2, acc2 -> [el2 | acc2] end)
      #end)
      l1 ++ l2 ++ l3 ++ l4
    #end)
  end

  def get_doors(mm) do
    mm |>  Map.values |> MapSet.new |>  Enum.filter( &(&1>="A" and &1<="Z")) |> Enum.sort
  end

  def get_keys(mm) do
    mm |>  Map.values |> MapSet.new |> Enum.filter( &(&1>="a" and &1<="z")) |> Enum.sort
  end

  def get_other_things(mm) do
    mm |>  Map.values |> MapSet.new |> Enum.filter( &( (&1<"a" or &1 >"z") and ( &1<"A" or &1 >"Z")))
  end

  def init_queue(mm) do
    q = PQ.new()
    st = get_initial_state(mm)

    PQ.put(q, {0, st})
  end

  def init_queue2(mm) do
    q = PQ.new()
    st = get_initial_state2(mm)

    PQ.put(q, {0, st})
  end

  def goal?(%{keys: keys}, key_num), do: Enum.count(keys) #|> IO.inspect == key_num

  def bfs(visited, queue, acc, mm, key_number) do

    if PQ.empty?(queue)  do
      acc
    else
      {{w, curr}, q} = PQ.pop(queue)
      #curr |> IO.inspect
      if goal?(curr, key_number) do
        curr
      else
        pos = Map.get(curr, :pos)
        keys = Map.get(curr, :keys)
        steps = Map.get(curr, :steps)

        if Map.get(visited, {pos, keys}) == nil do
          next_states = get_next_states(curr, mm)
          visited1 =  Map.put(visited, {pos, keys}, steps)
          queue1 =  Enum.reduce(next_states, q, &(PQ.put(&2, {steps, &1})))
          new_acc = Enum.filter(acc, &(Map.get(&1, :pos) != pos))
          bfs(visited1, queue1, [curr | new_acc], mm, key_number)
        else
          bfs(visited, q, [curr], mm, key_number)
        end

      end
    end
  end


  def bfs2(visited, queue, mm, key_number) do
    {Enum.count(visited), Enum.count(queue)} |> IO.inspect

    if PQ.empty?(queue)  do
      nil
    else
      {{w, curr}, q} = PQ.pop(queue)
      #w |> IO.inspect
      keys = Map.get(curr, :keys)
      curr_key_number = Map.get(curr, :key_number)
      #IO.write(curr_key_number)
      #IO.write(" ")
      # {key_number, curr_key_number} |> IO.inspect
      # {w, curr_key_number} |> IO.inspect
      if curr_key_number == key_number do
        curr
      else
        pos = Map.get(curr, :pos)

        steps = Map.get(curr, :steps)
        if not {pos, keys} in visited do
          next_states = get_next_states2(curr, visited, mm)
          visited1 =  MapSet.put(visited, {pos, keys})
          # queue1 =  Enum.reduce(next_states, q, &(PQ.put(&2, {steps-curr_key_number, &1})))
          queue1 = Enum.reduce(next_states, q, fn %{steps: steps2, key_number: key_number2} = el, qacc ->

            PQ.put(qacc, { {steps, -key_number2 }, el})
          end)
          #new_acc = Enum.filter(acc, &(Map.get(&1, :pos) != pos))
          #bfs2(visited1, queue1, [curr | new_acc], mm, key_number)
          bfs2(visited1, queue1, mm, key_number)
        else
          bfs2(visited, q,mm, key_number)
        end

      end
    end
  end


  def part1() do
    mm = input_to_map(read_input())
    q = init_queue(mm)
    key_number = get_keys(mm) |> Enum.count()
    bfs(%{}, q, [], mm, key_number )
  end

  def part1_test() do
    mm = input_to_map(test_input())
    q = init_queue(mm)
    key_number = get_keys(mm) |> Enum.count()
    bfs(%{}, q, [], mm, key_number )
  end


  def part2_test() do
    mm = input_to_map(test_input2())
    q = init_queue2(mm)
    key_number = get_keys(mm) |> Enum.count()
    bfs2(MapSet.new, q, mm, key_number )
  end


  def part2() do
    mm = input_to_map(read_input2())
    q = init_queue2(mm)
    key_number = get_keys(mm) |> Enum.count()
    bfs2(MapSet.new, q, mm, key_number )
  end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end
