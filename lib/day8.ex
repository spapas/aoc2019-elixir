defmodule Day8 do
  @width 25
  @height 6

  def get_input() do
    File.read!("day8.txt")|> String.trim() |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end
  def day8() do
    layers = get_input() |> Enum.chunk_every(@width * @height)
    min_0_layer = layers |> Enum.min_by(fn x ->
      x |> Enum.filter(&(&1==0)) |> Enum.count
    end)

    layer_1_num = min_0_layer |> Enum.filter(&(&1==1)) |> Enum.count
    layer_2_num = min_0_layer |> Enum.filter(&(&1==2)) |> Enum.count
    layer_1_num * layer_2_num

  end

  def layer_reducer(layer, acc) do
    Enum.zip(layer, acc) |> Enum.map(fn {l,a} ->
      if a == 2, do: l, else: a
    end)
  end

  def day8b() do
    layers = get_input() |> Enum.chunk_every(@width * @height)
    layers_test = [
      [0,2,2,2],
      [1,1,2,2],
      [2,2,1,2],
      [0,0,0,0]
    ]
    result = layers
    |> Enum.reduce(hd(layers), &layer_reducer/2)
    |> Enum.chunk_every(@width)
    |> Enum.map(fn l -> Enum.map(l, &(if &1==1, do: "#", else: " ")) |> Enum.join end) |> Enum.join("\r\n")
    IO.puts(result)
  end

end
