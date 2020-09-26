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
      {String.to_integer(q), s}
    end )
    [q, s] = r |> String.trim()
    |> String.split(" ")
    %{
      l: rr,
      r: {String.to_integer(q), s}
    }
  end

  def get_rule(pinput, right) do
    pinput |> Enum.filter(&(case &1 do
      %{l: _, r: {_, ^right}} -> true
      _ -> false
    end))
  end


end
