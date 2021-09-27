defmodule Day22 do

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
end
