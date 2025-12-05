defmodule AdventOfCode.Solutions.Y25.Day05 do
  alias AoC.Input
  alias AdventOfCode.Utils.RangeMapSet

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
    |> Enum.reject(&(&1 == ""))
    |> Enum.split_with(&String.contains?(&1, "-"))
    |> then(fn {ranges, fruits} ->
      %{
        ranges:
          ranges
          |> Enum.map(fn string ->
            string
            |> String.split("-")
            |> Enum.map(&String.to_integer/1)
            |> then(fn [ini, fin | []] -> ini..fin//1 end)
          end)
          |> RangeMapSet.new(),
        fruits: Enum.map(fruits, &String.to_integer/1)
      }
    end)
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem.fruits
    |> Enum.filter(fn x -> RangeMapSet.member?(problem.ranges, x) end)
    |> Enum.count()

    # |> IO.inspect()
  end

  # def part_two(problem) do
  #   problem
  # end
end
