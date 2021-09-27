defmodule Day20b do

  def read_input() do
    File.read!("day20.txt")
  end

  def test_input() do
"             Z L X W       C
             Z P Q B       K
  ###########.#.#.#.#######.###############
  #...#.......#.#.......#.#.......#.#.#...#
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
  #.#...#.#.#...#.#.#...#...#...#.#.......#
  #.###.#######.###.###.#.###.###.#.#######
  #...#.......#.#...#...#.............#...#
  #.#########.#######.#.#######.#######.###
  #...#.#    F       R I       Z    #.#.#.#
  #.###.#    D       E C       H    #.#.#.#
  #.#...#                           #...#.#
  #.###.#                           #.###.#
  #.#....OA                       WB..#.#..ZH
  #.###.#                           #.#.#.#
CJ......#                           #.....#
  #######                           #######
  #.#....CK                         #......IC
  #.###.#                           #.###.#
  #.....#                           #...#.#
  ###.###                           #.#.#.#
XF....#.#                         RF..#.#.#
  #####.#                           #######
  #......CJ                       NM..#...#
  ###.#.#                           #.###.#
RE....#.#                           #......RF
  ###.###        X   X       L      #.#.#.#
  #.....#        F   Q       P      #.#.#.#
  ###.###########.###.#######.#########.###
  #.....#...#.....#.......#...#.....#.#...#
  #####.#.###.#######.#######.###.###.#.#.#
  #.......#.......#.#.#.#.#...#...#...#.#.#
  #####.###.#####.#.#.#.#.###.###.#.###.###
  #.......#.....#.#...#...............#...#
  #############.#.#.###.###################
               A O F   N
               A A D   M                     "
  end

  def input_to_map(input) do
    input |> String.split(["\r\n", "\n"]) |> Enum.map( &String.graphemes/1) |> Enum.filter(&(Enum.count(&1)>0))
    |> Enum.with_index |> Enum.reduce(%{}, fn {v, y}, accy ->
      v |> Enum.with_index() |> Enum.reduce(accy, fn {v, x}, accx ->
        Map.put(accx, {x, y}, v)
      end)
    end)
  end

  def is_letter(c), do: c >="A" and c <= "Z"

  def fix_input(m) do
    Enum.reduce(m, %{}, fn {{x,y}, v}, acc ->
      # {{x, y}, v} |> IO.inspect
      case v do
        "#" -> Map.put(acc, {x-2, y-2}, "#")
        "." -> if Map.get(acc, {x-2, y-2}), do: acc, else: Map.put(acc, {x-2, y-2}, ".")
        v when v >= "A" and v <= "Z" ->
          cond do
            is_letter(Map.get(m, {x-1, y})) and Map.get(m, {x-2, y}) == "." -> Map.put(acc, {x-2-2, y-2}, Map.get(m, {x-1, y}) <> v) # .Av <-
            is_letter(Map.get(m, {x-1, y})) and Map.get(m, {x+1, y}) == "." -> Map.put(acc, {x-2+1, y-2}, Map.get(m, {x-1, y}) <> v) # Av. ->
            is_letter(Map.get(m, {x+1, y})) and Map.get(m, {x+2, y}) == "." -> Map.put(acc, {x-2+2, y-2}, v <> Map.get(m, {x+1, y})) # vA. ->
            is_letter(Map.get(m, {x+1, y})) and Map.get(m, {x-1, y}) == "." -> Map.put(acc, {x-2-1, y-2}, v <> Map.get(m, {x+1, y}) ) # .vA <-

            is_letter(Map.get(m, {x, y-1})) and Map.get(m, {x, y-2}) == "." -> Map.put(acc, {x-2, y-2-2}, Map.get(m, {x, y-1}) <> v )
            is_letter(Map.get(m, {x, y-1})) and Map.get(m, {x, y+1}) == "." -> Map.put(acc, {x-2, y-2+1},  Map.get(m, {x, y-1}) <> v)
            is_letter(Map.get(m, {x, y+1})) and Map.get(m, {x, y+2}) == "." -> Map.put(acc, {x-2, y-2+2}, v <> Map.get(m, {x, y+1}))
            is_letter(Map.get(m, {x, y+1})) and Map.get(m, {x, y-1}) == "." -> Map.put(acc, {x-2, y-2-1}, v <> Map.get(m, {x, y+1}))
          end

        _ -> acc
      end
    end)
  end

  def get_teleports(fixed_input) do
    teleports = Enum.reduce(fixed_input, %{}, fn {{x, y}, v}, acc ->
      if String.length(v) == 2  and v != "AA" and v != "ZZ" do
        {{xx, yy}, _v} = Enum.filter(fixed_input, fn {{xx, yy}, vv} ->
          vv == v and xx != x and yy != y
        end) |> Enum.at(0)
        Map.put(acc, {x, y}, {xx, yy})
      else
        acc
      end
    end)
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

  def get_start_pos(m) do
    Enum.filter(m, fn {{_x, _y}, v} ->
      v == "AA"
    end) |> Enum.at(0)
  end

  def get_initial_state(m) do

    %{
      pos: get_start_pos(m),
      steps: 0,
      level: 0

    }
  end

  def init_queue(m) do
    q = get_queue()
    push(q, get_initial_state(m))
  end

  def get_next_state(%{pos: {x, y}, steps: steps, level: level}, mm, teleports, mx, my) do
    v = Map.get(mm, {x, y})
    if v == "." or (level == 0 and (v == "AA" or v == "ZZ")) do
      %{pos: {{x, y}, v}, steps: steps+1, level: level}
    else
      p = Map.get(teleports, {x, y})
      if p != nil do
        if x == 0 or x == mx or y == 0 or y == my do
          if level > 0 do
            %{pos: {p, v}, steps: steps+2, level: level-1}
          else
            nil
          end
        else
          %{pos: {p, v}, steps: steps+2, level: level+1}
        end
      else
        nil
      end
    end
  end

  def get_next_states(%{pos: {{x, y}, _v}, steps: steps, level: level}, mm, teleports, mx, my) do
    p1 = {x - 1, y}
    p2 = {x + 1, y}
    p3 = {x, y - 1}
    p4 = {x, y + 1}
    [p1, p2, p3, p4]
    |> Enum.map(fn p ->
      get_next_state(%{ pos: p, steps: steps, level: level}, mm, teleports, mx, my)
    end)
    |> Enum.filter(fn s -> s != nil end)
  end


  def bfs(visited, queue, acc, map, teleports, mx, my) do

    if empty?(queue)  do
      # acc
      IO.inspect("EMPTY")
    else
      {curr, q} = pop(queue)
      {pos, v} = Map.get(curr, :pos)
      level = Map.get(curr, :level)

      if Map.get(map, pos) == "ZZ" and level == 0 do
        curr
      else
        if {pos, level} in visited do
          bfs(visited, q, acc, map, teleports, mx, my)
        else
          next_states = get_next_states(curr, map, teleports, mx, my )

          visited1 =  MapSet.put(visited, {pos, level})
          queue1 =  Enum.reduce(next_states, q, &(push(&2, &1)))

          bfs(visited1, queue1, [curr | acc], map, teleports, mx, my)
        end

      end
    end
  end

  def part2_test do
    fixed_input = test_input|>input_to_map|>fix_input
    teleports = get_teleports(fixed_input)
    {{mx, _y}, _v} = Enum.max_by(fixed_input, fn {{x, _y}, _v} -> x end)
    {{_x, my}, _v} = Enum.max_by(fixed_input, fn {{_x, y}, _v} -> y end)
    q = init_queue(fixed_input)
    bfs(MapSet.new, q, [], fixed_input, teleports, mx, my)
  end

  def part2 do
    fixed_input = read_input|>input_to_map|>fix_input
    teleports = get_teleports(fixed_input)
    {{mx, _y}, _v} = Enum.max_by(fixed_input, fn {{x, _y}, _v} -> x end)
    {{_x, my}, _v} = Enum.max_by(fixed_input, fn {{_x, y}, _v} -> y end)
    q = init_queue(fixed_input)
    bfs(MapSet.new, q, [], fixed_input, teleports, mx, my)
  end




end
