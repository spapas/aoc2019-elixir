defmodule Intcode do

  def get_op(op_modes), do: rem(op_modes, 100)
  def get_modes(0, modes, _idx), do: modes
  def get_modes(num, modes, idx) do
    # mode idx starts with 1 not 0
    get_modes(div(num, 10), Map.put(modes, idx+1, rem(num, 10)), idx+1)
  end

  def get_param_value(progr, pc, modes, idx) do
    if Map.get(modes, idx, 0) == 0 do
      ptr = Map.get(progr, pc+idx)
      Map.get(progr, ptr)
    else
      Map.get(progr, pc + idx)
    end
  end

  def runner(progr, pc) do
    op_modes = progr |> Map.get(pc)
    op = get_op(op_modes)
    modes = get_modes(div(op_modes, 100), %{}, 0)

    case op do
      99 ->
        progr

      1 ->
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        #p1 = Map.get(progr, pc + 1)
        #p2 = Map.get(progr, pc + 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, p1 + p2)
        runner(new_progr, pc + 4)

      2 ->
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, p1*p2)
        runner(new_progr, pc + 4)
      3 ->
        i = IO.gets("Enter input: ") |> String.trim |> String.to_integer
        p1 = Map.get(progr, pc + 1)
        new_progr = progr |> Map.put(p1, i)
        runner(new_progr, pc + 2)
      4 ->
        p1 = Map.get(progr, pc + 1)

        IO.inspect("OUTPUT: ")
        IO.inspect(Map.get(progr, p1))
        runner(progr, pc + 2)
      end
  end

  def read_program(input) do
    File.read!(input)
    |> String.trim()
    |> String.split(",")
    |> Enum.with_index
    |> Enum.map(fn {f,s} -> {s, String.to_integer(f)} end)
    |> Map.new
  end

  def intlist_to_program(input) do
    input
    |> Enum.with_index
    |> Enum.map(fn {f,s} -> {s, f} end)
    |> Map.new
  end
end
