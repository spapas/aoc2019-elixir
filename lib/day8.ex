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

  def day8b() do

  end

end
