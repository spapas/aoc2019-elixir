defmodule Day22 do

  @l 119315717514047
  @n 101741582076661
# https://github.com/metalim/metalim.adventofcode.2019.python/blob/master/22_cards_shuffle.ipynb
  def read_input() do
    File.read!("day22.txt")|> String.split(["\n", "\r\n"])
  end

  def test_input() do
"deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1"|> String.split(["\n", "\r\n"])
  end

  def shuffle_reducer(instruction, deck) do

    case instruction do
      "deal into new stack" -> Enum.reverse(deck)
      "deal with increment " <> s_increment ->
        cnt = Enum.count(deck)
        s_increment
        increment = String.to_integer(s_increment)
        Enum.map(0..(cnt-1), fn idx ->
          {rem(idx * increment, cnt), Enum.at(deck, idx)}
        end) |> Enum.sort |> Enum.map(&(&1|>elem(1)))
      "cut " <> s_cut ->
        cut = String.to_integer(s_cut)
        if cut < 0 do
          Enum.take(deck, cut) ++ Enum.drop(deck, cut)
        else
          Enum.drop(deck, cut) ++ Enum.take(deck, cut)
        end
    end
  end

  def part1_test() do
    Enum.reduce(test_input, Enum.to_list(0..9), &shuffle_reducer/2)

  end

  def part1() do
    r = Enum.reduce(read_input, Enum.to_list(0..10006), &shuffle_reducer/2)
    r |> Enum.find_index(&(&1==2019))
  end

  def  pow(n, k), do: Integer.pow(n, k)

  def shuffle_reducer2(instruction, {a,b}) do
    instruction |> IO.inspect
    {a, b} |> IO.inspect
    case instruction do
      "deal into new stack" -> {-a, @l-b-1}
      "deal with increment " <> s_increment ->
        increment = String.to_integer(s_increment)
        z = powmod(increment, @l-2, @l)
        {"ZZZ", z} |> IO.inspect
        {rem(a*z, @l), rem(b*z, @l)}
      "cut " <> s_cut ->
        cut = String.to_integer(s_cut)
        {a, rem(b+cut, @l)}
    end
  end

  def polypow(_a, _b, 0, _n), do: {1, 0}
  def polypow(a,b,m,n) do
    if (rem(m, 2) == 0) do
      # polypow(a*a%n, (a*b+b)%n, m//2, n)
      polypow(rem(a*a,n ), rem(a*b + b, n), div(m, 2), n)
    else
      # c,d = polypow(a,b,m-1,n)
      # return a*c%n, (a*d+b)%n}
      {c, d} = polypow(a,b,m-1,n)
      { rem(a*c, n), rem(a*d + b, n) }
    end
  end

  def part2() do
    {a, b} = read_input |> Enum.reverse |> Enum.reduce({1, 0}, &shuffle_reducer2/2) |> IO.inspect
    {a, b} = polypow(a, b, @n, @l)|> IO.inspect
    rem(2020 * a + b, @l)
  end
# 1267643307106 no
# 111557929578064 no too high
  def powmod(a, b, m), do: powmod(a, b, m, 1)
  def powmod(n, 0, m, r), do: r
  def powmod(a, b, m, r) when rem(b, 2) == 1,  do: powmod(a, b-1,m, rem(a*r, m))
  def powmod(a, b, m, r), do: powmod( rem(a*a, m), div(b,2),m, r)


end
