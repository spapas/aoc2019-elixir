defmodule Day10 do


  def read_input() do
    File.read!("day10.txt") |> String.split() |> Enum.map( fn el ->
      el |> String.graphemes() |> Enum.map(&(if &1=="#", do: 1, else: 0))
    end)
  end



  def day10 do
    grid = read_input()
    h = grid |> Enum.count()
    w = grid |> Enum.at(0) |> Enum.count()

    grid |> Enum.with_index() |> Enum.map( fn {line, y} ->
      line |> Enum.with_index() |> Enum.map( fn {point, x} ->
        "x = #{x}, y = #{y}, is asteroid = #{point}" |> IO.inspect()

      end)
    end)


  end

  def day10b do

  end
end
