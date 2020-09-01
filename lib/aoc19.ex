defmodule Aoc19 do
  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x,y))

  def lcm(x, y), do: x * div(y  ,gcd(x,y ))
end
