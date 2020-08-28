defmodule Day10 do


  def read_input() do
    File.read!("day10.txt") |> String.split() |> Enum.map( fn el ->
      el |> String.graphemes() |> Enum.map(&(if &1=="#", do: 1, else: 0))
    end)
  end

  def get_map(grid) do

    grid |> Enum.with_index() |> Enum.map( fn {line, y} ->
      line |> Enum.with_index() |> Enum.map( fn {point, x} ->
        #"x = #{x}, y = #{y}, is asteroid = #{point}" |> IO.inspect()
        {{x,y}, point}

      end)
    end)
    |> Enum.reduce([], fn l, acc -> Enum.reduce(l, acc, &[&1 | &2]) end )
    |> Map.new

  end

  def get_locations_quart(rx, ry) do
    #h = grid |> Enum.count()
    #w = grid |> Enum.at(0) |> Enum.count()

    #oob = fn(x, y) ->
    #  x > w or x < 0 or y > h or y < 0
    #end



  end

  def get_locations_around(grid, h, w, {px, py}) do


    # TOP LEFT
    (for x <- px..0, y <- py..0, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end ) |> IO.inspect
    # TOP RIGHT
    (for x <- px..w, y <- py..0, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
    # BOTTOM RIGHT
    (for x <- px..w, y <- py..h, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
    # BOTTOM LEFT
    (for x <- px..0, y <- py..h, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
  end


  def day10 do
    grid = read_input()
    h = grid |> Enum.count()
    w = grid |> Enum.at(0) |> Enum.count()

    mapgrid = get_map(grid)

  end

  def day10b do

  end

  def pranges(x,y, x, y, acc), do: acc |> Enum.reverse
  def pranges(x,y, lx, ly, acc) when x == y, do: pranges(x+1, y, lx, ly, [{x, y} | acc])
  def pranges(x,y, lx, ly, acc) when x > y, do: pranges(x, y+1, lx, ly, [{x-1, y+1} | acc])
  #def pranges(x,y, lx, ly, acc), do: pranges(x-1, y+1, lx, ly, [{x-1, y} | acc])
  #def pranges(x,y, lx, ly, acc) when x < y, do: pranges(x+1, y, lx, ly, [{x, y} | acc])

end
