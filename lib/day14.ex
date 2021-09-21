defmodule Day14 do


  @input00 """
  10 ORE => 10 A
  1 ORE => 1 B
  7 A, 1 B => 1 C
  7 A, 1 C => 1 D
  7 A, 1 D => 1 E
  7 A, 1 E => 1 FUEL
"""
@input0 """
2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
"""

@input """
3 LMPDB, 11 CBTKP => 7 PZDPS
5 CBKW, 4 CXBH => 9 KXNDF
1 LVDN, 4 HGDHV => 1 PCXS
11 PCXS => 2 XTBRS
5 RVSF => 7 TDCH
1 CXBH, 6 PXVN => 8 GQXV
3 DBCB, 3 QLNK => 4 CTFCD
7 PZDPS, 18 HGDHV, 9 TBKM => 4 JHVL
10 QGSV, 1 DBCB, 7 LTHFX => 3 BLRSQ
12 CBTKP, 7 SPBF => 5 KSQL
1 QXHDQ, 5 MQKH, 10 XRCB, 30 SQWHX, 2 PQZVD, 30 TFST, 39 JPFC, 1 FDGS, 17 LVDN => 1 FUEL
2 TBKM => 8 PFHKT
13 CBTKP => 5 QLNK
12 TVRDM, 6 QGSV, 16 LMPDB => 4 PQZVD
7 TDCH, 17 PXVN, 4 ZLKZ => 6 XRCB
1 QBJQ, 26 CBKW => 4 RVSF
24 KXNDF, 3 BLRSQ => 9 GSHKQ
12 BLRSQ, 3 HGDHV => 9 RQNGQ
2 RFBK, 2 WHWS => 8 CBKW
1 WHWS => 7 LTHFX
13 CKQLD, 10 ZLKZ, 2 GQXV => 8 TVHC
1 DBCB => 2 JZXKW
8 SPBF => 7 CXBH
11 LTHFX, 1 PTGLG, 10 NCQTM => 6 SQWHX
16 PFHKT => 3 HGDHV
3 LVDN, 5 PZDPS, 1 SPBF => 9 CQBCL
19 BLRSQ, 1 BLQRD, 5 GSHKQ, 2 LVDN, 3 LMPDB, 5 KTJR => 1 QXHDQ
1 RFBK, 1 JPFC => 7 PXVN
110 ORE => 3 MQKH
1 FPBRB, 7 MQKH => 7 SDJBT
128 ORE => 7 FPBRB
3 WRWGP => 2 RFBK
1 PFHKT, 4 SPBF => 7 JPFC
14 LTHFX, 2 JZXKW, 2 BLRSQ, 2 MHVJP, 6 RQNGQ, 1 CQBCL, 8 TDCH, 2 NJTR => 2 FDGS
4 SDJBT, 2 LMPDB => 8 PLGS
1 RFBK, 1 TBKM => 6 CBTKP
17 LVDN, 2 CBTKP => 4 QGSV
7 WRWGP => 9 LMPDB
3 CKQLD => 6 WHWS
14 CBTKP, 9 XTBRS, 9 GSHKQ, 12 GQXV, 20 LTHFX, 1 RQNGQ, 1 KTJR, 3 BLRSQ => 7 TFST
1 QPCQ => 5 BLQRD
6 QGSV, 1 HGDHV, 1 JPFC => 1 NJTR
1 HGDHV, 7 JHVL, 5 PZDPS => 9 MGRT
1 KSQL => 5 QBJQ
2 QLNK => 2 CKQLD
13 JZXKW, 14 XTBRS => 3 PTGLG
1 BNPXT, 2 PLGS => 7 DBCB
1 RFBK, 9 CTFCD => 1 MHVJP
1 NJTR, 1 TVHC, 2 PCXS => 1 KTJR
2 WRWGP => 6 TBKM
12 QLNK, 1 NJTR => 3 NCQTM
13 ZHCKP, 2 DBCB, 5 PXVN => 9 QPCQ
125 ORE => 3 WRWGP
6 CBTKP, 9 TBKM => 9 SPBF
1 GQXV => 6 ZHCKP
1 MGRT => 8 BNPXT
2 SPBF => 4 ZLKZ
9 TVHC, 5 KXNDF, 3 QPCQ => 3 TVRDM
1 PLGS, 7 TBKM => 8 LVDN
"""


  def get_input() do
    @input
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.filter(&(&1!=""))
    |> Enum.map(&parse_input_line/1)
  end

  def parse_input_line(input) do
    [l, r] = input |> String.split("=>")
    rr = l
    |> String.trim()
    |> String.split(",")
    |> Enum.map( fn ll ->
      [q, s] = ll |> String.trim() |> String.split(" ")
      {s, String.to_integer(q)}
    end ) |> Map.new
    [q, s] = r |> String.trim()
    |> String.split(" ")
    %{
      l: rr,
      r: {String.to_integer(q), s}
    }
  end

  def get_rule(pinput, right) do
    [hd | _ ] = pinput |> Enum.filter(&(case &1 do
      %{l: _, r: {_, ^right}} -> true
      _ -> false
    end))
    hd
  end

  def get_initial_state(pinput) do
    %{ l: l, r: _} = get_rule(pinput, "FUEL")
    l
  end

  def get_map_input(pinput) do
    pinput |> Enum.map(fn %{l: l, r: {amt, ingr}} ->
      {ingr, %{amt: amt, l: l}}
     end) |> Map.new
  end

  def check_inventory(material, amount, inventory) do
    inv_amt = Map.get(inventory, material, 0)

    if inv_amt >= amount do
      {0, Map.put(inventory, material, inv_amt - amount)}
    else
      # inv_amt < amount
      {amount - inv_amt, Map.put(inventory, material, 0)}
    end
  end

  def get_number_of_iterations(needed_amount,  recipe_amt) do
    div(needed_amount,  recipe_amt) + 1 - if rem(needed_amount, recipe_amt) == 0, do: 1, else: 0
  end

  def calculate_cost("ORE", amount, inventory, _recipies), do: {amount, inventory}
  def calculate_cost(material, amount, inventory, recipies) do
    "#{material}, #{amount}"
    inventory
    {needed_amount, inventory} = check_inventory(material, amount, inventory)
    inventory
    if needed_amount > 0 do
      %{amt: recipe_amt, l: recipe_ingredients} = Map.get(recipies, material)
      number_of_iterations = get_number_of_iterations(needed_amount, recipe_amt)
      produced = number_of_iterations * recipe_amt

      inventory = Map.update(inventory, material, produced - needed_amount, fn existing ->
        existing + produced - needed_amount
      end)

      Enum.reduce(recipe_ingredients, {0, inventory}, fn {m, a}, {acc_tot, acc_inv} ->
        {c, i} = calculate_cost(m, a * number_of_iterations, acc_inv, recipies)
        {acc_tot + c, i}
      end)

    else
      {0, inventory}
    end

  end

  def get_input_ok() do
    pi = get_input() |> parse_input() |> get_map_input()
  end

  def part1() do
    mi = get_input_ok()
    calculate_cost("FUEL", 1, %{}, mi)
    # q = init_queue(pi)
    # bfs(MapSet.new, q, mi, []) |> Enum.min

  end

  def search(n, mi) do
    {cost, _inv} = calculate_cost("FUEL", n, %{}, mi)
    {n, cost} |> IO.inspect
    if cost > 1000000000000 do
      {cost, n - 1}
    else
      search(n+1,mi)

    end
  end

  def part2() do

    mi = get_input_ok()
    search(13100000, mi)

  end


end
