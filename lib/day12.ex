defmodule Day12 do
  @input [
    %{x: -4, y: -14, z: 8, vx: 0, vy: 0, vz: 0},
    %{x: 1, y: -8, z: 10, vx: 0, vy: 0, vz: 0},
    %{x: -15, y: 2, z: 1, vx: 0, vy: 0, vz: 0},
    %{x: -17, y: -17, z: 16, vx: 0, vy: 0, vz: 0}
  ]

  @input_test [
    %{x: -1, y: 0, z: 2, vx: 0, vy: 0, vz: 0},
    %{x: 2, y: -10, z: -7, vx: 0, vy: 0, vz: 0},
    %{x: 4, y: -8, z: 8, vx: 0, vy: 0, vz: 0},
    %{x: 3, y: 5, z: -1, vx: 0, vy: 0, vz: 0}
  ]

  def get_input(), do: @input

  def getdv(v1, v2) do
    cond do
      v1 > v2 -> -1
      v1 < v2 -> 1
      true -> 0
    end
  end

  def step(planets) do
    velocities =
      planets
      |> Enum.map(fn %{x: x, y: y, z: z, vx: vx, vy: vy, vz: vz} = planet ->
        planets
        |> Enum.reject(&(&1 == planet))
        |> Enum.reduce(%{vx: vx, vy: vy, vz: vz}, fn %{x: px, y: py, z: pz},
                                                     %{vx: pvx, vy: pvy, vz: pvz} ->
          %{
            vx: pvx + getdv(x, px),
            vy: pvy + getdv(y, py),
            vz: pvz + getdv(z, pz)
          }
        end)
      end)

    Enum.zip(planets, velocities)
    |> Enum.map(fn {%{x: x, y: y, z: z}, %{vx: pvx, vy: pvy, vz: pvz}} ->
      %{x: x + pvx, y: y + pvy, z: z + pvz, vx: pvx, vy: pvy, vz: pvz}
    end)
  end

  def get_energy(planets) do
    planets
    |> Enum.reduce(0, fn %{x: x, y: y, z: z, vx: vx, vy: vy, vz: vz}, acc ->
      acc + (abs(x) + abs(y) + abs(z)) *(abs(vx) + abs(vy) + abs(vz))
    end)
  end

  def looper(input, 0), do: input |> get_energy()
  def looper(input, times), do: looper(step(input), times - 1)

  def day12 do
    get_input() |> looper(1000)

  end
end
