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

  def runner(progr, pc, options \\ []) do
    IO.puts("Starting runner with opts = #{options|>inspect}")
    op_modes = progr |> Map.get(pc)
    op = get_op(op_modes)
    modes = get_modes(div(op_modes, 100), %{}, 0)

    case op do
      99 -> # halt
        IO.puts("HALT")
        {Keyword.get(options, :output, []) |> Enum.reverse, progr}

      1 -> # add
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        #p1 = Map.get(progr, pc + 1)
        #p2 = Map.get(progr, pc + 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, p1 + p2)
        runner(new_progr, pc + 4, options)

      2 -> # mult
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        p3 = Map.get(progr, pc + 3)
        new_progr = progr |> Map.put(p3, p1*p2)
        runner(new_progr, pc + 4, options)
      3 -> # input
        the_input = Keyword.get(options, :input)
        IO.puts("Here's the input #{the_input|>inspect()}!")
        if Enum.count(the_input) > 0 do
          {i, new_options} = if the_input  do
            {
              hd(the_input),
              Keyword.update!(options, :input, &tl/1 )
            }

          else
            {
              IO.gets("Enter input: ") |> String.trim |> String.to_integer,
              []
            }
          end
          IO.puts("So i retr this input #{i}")

          p1 = Map.get(progr, pc + 1)
          new_progr = progr |> Map.put(p1, i)
          runner(new_progr, pc + 2, new_options)
        else
          IO.puts("Will block waiting ...")
          {:block, progr, pc, options}
        end
      4 -> # output
        p1 = get_param_value(progr, pc, modes, 1)
        IO.puts("OUTPUT : #{p1}")

        new_options = options |> Keyword.update(:output, [p1], &([p1 | &1]))
        runner(progr, pc + 2, new_options)
      5 -> # jump if true
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        if p1 != 0 do
          runner(progr, p2, options)
        else
          runner(progr, pc + 3, options)
        end
      6 -> # jump if false
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        if p1 == 0 do
          runner(progr, p2, options)
        else
          runner(progr, pc + 3, options)
        end
      7 -> # less than
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        p3 = Map.get(progr, pc + 3)

        new_progr = if p1 < p2 do
          progr |> Map.put(p3, 1)
        else
          progr |> Map.put(p3, 0)
        end
        runner(new_progr, pc + 4, options)
      8 -> # eq
        p1 = get_param_value(progr, pc, modes, 1)
        p2 = get_param_value(progr, pc, modes, 2)
        p3 = Map.get(progr, pc + 3)

        new_progr = if p1 == p2 do
          progr |> Map.put(p3, 1)
        else
          progr |> Map.put(p3, 0)
        end
        runner(new_progr, pc + 4, options)
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
