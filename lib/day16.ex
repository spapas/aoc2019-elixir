defmodule Day16 do
  # pattern 0, 1, 0, -1

  def read_input() do
    File.read!("day16.txt") |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def test_input() do
    # [1, 2, 3, 4, 5, 6, 7, 8]
    "03036732577212944063491565474664" |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def get_pattern_by_pos(i) do
    a = 0..i |> Enum.map(fn _x -> 0 end)
    b = 0..i |> Enum.map(fn _x -> 1 end)
    c = 0..i |> Enum.map(fn _x -> 0 end)
    d = 0..i |> Enum.map(fn _x -> -1 end)

    basic_pattern = a ++ b ++ c ++ d
    [h | t ] = basic_pattern
    t ++ [h]
  end

  def get_value_by_pattern(i, j, mem) do
    #pattern = get_pattern_by_pos(i)
    pattern = Map.get(mem, i)
    Enum.at(pattern, rem(j, 4*(i+1)))
  end


  def get_value_by_pattern_no_mem(i, j ) do
    pattern = get_pattern_by_pos(i)
    # pattern = Map.get(mem, i)
    Enum.at(pattern, rem(j, 4*(i+1)))
  end

  def get_digit(i) do
    rem(abs(i), 10)
  end

  def fix_mem(input) do
    len = Enum.count(input)
    0..(len-1) |> Enum.reduce(%{}, fn el, acc -> Map.put(acc, el, get_pattern_by_pos(el)) end)
  end

  def calculate_phase(input, mem) do
    len = Enum.count(input)
    0..(len-1) |> Enum.map(fn i ->
      input |> Enum.with_index |> Enum.map(fn {v, j} ->
        get_value_by_pattern(i, j, mem) * v
      end) |> Enum.sum |> get_digit
    end)
  end

  def calc_phases(input, 0, _mem), do: input
  def calc_phases(input, phases, mem) do
    calc_phases(calculate_phase(input, mem), phases-1, mem)
  end

  def part1() do
    input = read_input()
    mem = fix_mem(input)
    calc_phases(input, 100, mem) |> IO.inspect|> Enum.take(8) |> Enum.join("")

  end

  def part1_test() do
    input = test_input()
    mem = fix_mem(input)
    calc_phases(input, 100, mem) |> IO.inspect |> Enum.take(8) |> Enum.join("")

  end

  def get_offset(input) do
    input |> Enum.take(7) |> Enum.join |> String.to_integer
  end


  def repeat(arr, 0, acc), do: acc
  def repeat(arr, n, acc) do
    repeat(arr, n-1, arr ++ acc)
  end

  def part2_reducer(el, []), do: [el]
  def part2_reducer(el, [h|_t]=acc), do: [ rem(h+el, 10)|acc]
  def do_part2(nums, 0), do: nums
  def do_part2(nums, times) do
    nums2 = nums |> Enum.reverse |> Enum.reduce([], &part2_reducer/2)
    do_part2(nums2, times-1)
  end

  def part2_test() do
    input = test_input()
    rinput = repeat(input, 10000, [])
    offset = get_offset(input)
    nums = Enum.drop(rinput, offset)
    do_part2(nums, 100) |> Enum.take(8) |> Enum.join("")
  end

  def part2() do
    input = read_input()
    rinput = repeat(input, 10000, [])
    offset = get_offset(input)
    nums = Enum.drop(rinput, offset)
    do_part2(nums, 100) |> Enum.take(8) |> Enum.join("")
  end

end
