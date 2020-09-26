defmodule Day4 do
  @input_from 168630
  @input_to 718098

  def get_range, do: @input_from..(@input_to+1)

  def to_list(n) do
    n |> to_string |> String.graphemes |> Enum.map(&String.to_integer/1)
  end

  def filter(n) do
    l = n |> to_list
    f1(l, nil) and f2(l, 0)
  end

  def filter_numbers do
    get_range() |> Enum.filter(&filter/1)
  end

  def f1([], _p) do
    false
  end

  def f1([h|t], p) do
    if h == p, do: true, else: f1(t, h)
  end

  def f2([], _p) do
    true
  end

  def f2([h|t], p) do
    if h < p, do: false, else: f2(t, h)
  end

  def day4() do
    filter_numbers() |> Enum.count()
  end

  def f3(l) do
    l |> Enum.frequencies |> Enum.any?(&(&1|>elem(1)==2))
  end

  def day4b() do
    filter_numbers() |> Enum.filter(&(&1 |> to_list |> f3)) |> Enum.count()
  end


end
