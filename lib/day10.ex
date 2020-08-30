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

  def location_sort(l, {px, py}) do
    l|> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )
  end

  def get_locations_tl({_px, py}, _w, _h) when  py==0, do: []
  def get_locations_tl({px, py}=p, _w, _h) when px == 0 do
    (for y <- (py-1)..0, do: {0, y}) |> location_sort(p)
  end
  def get_locations_tl({px, py}=p, _w, _h) do
    (for x <- px..0, y <- (py-1)..0, do: {x, y}) |> location_sort(p)
  end

  def get_locations_tr({px, _py}, w, _h) when px == w-1, do: []
  def get_locations_tr({px, py}=p, w, _h) when py == 0 do
    (for x <- (px+1)..(w-1), do: {x, 0}) |> location_sort(p)
  end
  def get_locations_tr({px, py}=p, w, _h) do
    (for x <- (px+1)..(w-1), y <- py..0, do: {x, y}) |> location_sort(p)
  end

  def get_locations_br({_px, py}, _w, h) when  py==h-1, do: []
  def get_locations_br({px, py}=p, w, h) when px == w-1 do
    (for y <- (py+1)..(h-1), do: {w-1, y}) |> location_sort(p)
  end
  def get_locations_br({px, py}=p, w, h) do
    (for x <- px..(w-1), y <- (py+1)..(h-1), do: {x, y}) |> location_sort(p)
  end

  def get_locations_bl({px, _py}, _w, _h) when px == 0, do: []
  def get_locations_bl({px, py}=p, _w, h) when py == (h-1) do
    (for x <- (px-1)..0, do: {x, h-1}) |> location_sort(p)
  end
  #def get_locations_bl({px, py}=p, _w, h) when px == 0 do
  #  (for y <- (py+1)..(h-1), do: {0, y}) |> location_sort(p)
  #end
  def get_locations_bl({px, py}=p, _w, h) do
    (for x <- (px-1)..0, y <- py..(h-1), do: {x, y}) |> location_sort(p)
  end

  def disp_locations(locs, sl, w, h) do
    for y <- 0..w-1 do
      for x <- 0..h-1 do
          IO.write(
            cond do
              {x,y} == sl -> '@'
              {x,y} in locs -> 'x'
              true -> '.'
            end
          )

          #if {x,y} in locs, do: 'x', else: '.')
      end
      IO.write('\n')
    end
  end

  def test_locations() do
    w = 111
    h = 111
    tot = w * h - 1
    for y <- 0..w-1 do
      for x <- 0..h-1 do
        r = (get_locations_tl({x, y}, w, h)|>Enum.count()) +
        (get_locations_tr({x, y}, w, h)|>Enum.count()) +
        (get_locations_br({x, y}, w, h)|>Enum.count()) +
        (get_locations_bl({x, y}, w, h)|>Enum.count())
        {x,y,r, (if r==tot, do: "OK", else: "ERR")} |> IO.inspect
      end
    end
  end

  def get_locations_around(grid, h, w, {px, py}) do

    # TOP RIGHT
    "TR"|>IO.puts
    (for x <- (px+1)..(w-1), y <- py..0, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
    # BOTTOM RIGHT
    "BR"|>IO.puts
    (for x <- px..(w-1), y <- (py+1)..(h-1), do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
    # BOTTOM LEFT
    "BL"|>IO.puts
    (for x <- (px-1)..0, y <- py..(h-1), do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end )  |> IO.inspect
    # TOP LEFT
    "TL"|>IO.puts
    (for x <- px..0, y <- (py-1)..0, do: {x, y}) |> Enum.sort_by(fn {x, y} -> abs(px-x)+abs(py-y) end ) |> IO.inspect
    "~"
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

###
# #
###
