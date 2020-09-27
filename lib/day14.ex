defmodule Day14 do
  @input """
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
"""

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

  def get_input() do
    @input
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(&(&1!=""))
    |> Enum.map(&parse_input_line/1)
  end

  def parse_input_line(input) do
    [l, r] = input |> String.split("=>")
    rr = l
    |> String.trim()
    |> String.split(",")
    |> Enum.map( fn ll ->
      [q, s] = ll |> String.trim() |> String.split(" ")
      {s, String.to_integer(q)}
    end ) |> Map.new
    [q, s] = r |> String.trim()
    |> String.split(" ")
    %{
      l: rr,
      r: {String.to_integer(q), s}
    }
  end

  def get_rule(pinput, right) do
    [hd | _ ] = pinput |> Enum.filter(&(case &1 do
      %{l: _, r: {_, ^right}} -> true
      _ -> false
    end))
    hd
  end

  def get_initial_state(pinput) do
    %{ l: l, r: _} = get_rule(pinput, "FUEL")
    l
  end

  def get_map_input(pinput) do
    pinput |> Enum.map(fn %{l: l, r: {amt, ingr}} ->
      {ingr, %{amt: amt, l: l}}
     end) |> Map.new
  end

  def get_next_states(state, minput) do
    state |> Enum.map(fn {ingr, amt} ->
      if ingr == "ORE" do
        state
      else
        %{amt: recipy_amt, l: ll }= minput |> Map.get(ingr)
        mult =  round(amt / recipy_amt)

        {_, s} = state |> Map.pop(ingr)
        ll |> Map.merge(s, fn _k, v1, v2 -> mult * v1+v2 end)
      end
    end)
  end

  def init_queue(pinput) do
    q = get_queue()
    push(q, get_initial_state(pinput))
  end

  def bfs(visited, queue, minput) do
    if empty?(queue) do
      "OK"
    else
      {curr, q} = pop(queue)
      if curr in visited do
        "REVISIT"
      else
        v2 = visited |> MapSet.put(curr)
        q2 = curr |> IO.inspect()
        |> get_next_states(minput)
        |> Enum.reduce(q, &(push(&2, &1)))
        bfs(v2, q2, minput)
      end
    end
  end



end
