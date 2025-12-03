defmodule AdventOfCode.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    # This function will receive the input path or an %AoC.Input.TestInput{}
    # struct. To support the test you may read both types of input with either:
    #
    # * Input.stream!(input), equivalent to File.stream!/1
    # * Input.stream!(input, trim: true), equivalent to File.stream!/2
    # * Input.read!(input), equivalent to File.read!/1
    #
    # The role of your parse/2 function is to return a "problem" for the solve/2
    # function.
    #
    # For instance:
    #
    # input
    # |> Input.stream!()
    # |> Enum.map!(&my_parse_line_function/1)

    Input.read!(input)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn list -> list |> String.graphemes() |> Enum.map(&String.to_integer/1) end)
  end

  defp get_max_joltage_part_one([a, b | numbers_list]) do
    numbers_list
    |> Enum.reduce({a, b, a * 10 + b}, fn n, {a, b, acc_number} ->
      a_number = a * 10 + n
      b_number = b * 10 + n
      result = max(a_number, b_number) |> max(acc_number)

      cond do
        result == acc_number -> {a, b, acc_number}
        result == a_number -> {a, n, a_number}
        result == b_number -> {b, n, b_number}
        true -> :error
      end
    end)
    |> elem(2)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&get_max_joltage_part_one/1)
    # |> IO.inspect()
    |> Enum.sum()
  end

  # def part_two(problem) do
  #   problem
  # end
end
