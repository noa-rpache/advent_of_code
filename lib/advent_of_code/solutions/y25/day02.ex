defmodule AdventOfCode.Solutions.Y25.Day02 do
  require Integer
  alias AoC.Input

  @regex ~r"^(.+)\1+$"

  def parse(input, _part) do
    Input.read!(input)
    |> String.replace("\n", "")
    |> String.split(",")
    |> Enum.map(fn input ->
      input
      |> String.split("-")
      |> then(fn [h1, h2 | _t] -> String.to_integer(h1)..String.to_integer(h2) end)
    end)
  end

  def part_one(problem) do
    problem
    |> solve()
  end

  def part_two(problem) do
    problem
    |> solve(false)
  end

  defp solve(problem, part_1 \\ true) do
    problem
    |> Enum.map(
      &Enum.filter(&1, fn r ->
        r_str = Integer.to_string(r)
        r_len = String.length(r_str)

        case part_1 do
          true -> not part_one_criteria(r_str, r_len)
          false -> not part_two_criteria(r_str)
        end
      end)
    )
    |> Enum.reduce(0, fn sublist, acc ->
      acc + Enum.sum(sublist)
    end)
  end

  defp part_one_criteria(input, len) do
    cond do
      Integer.mod(len, 2) != 0 ->
        true

      input
      |> String.to_charlist()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.any?(fn count -> Integer.mod(count, 2) != 0 end) ->
        true

      true ->
        part_two_criteria(input)
    end
  end

  defp part_two_criteria(input) do
    cond do
      Regex.match?(@regex, input) ->
        false

      true ->
        true
    end
  end
end
