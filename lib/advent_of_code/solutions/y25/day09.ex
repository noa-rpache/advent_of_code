defmodule AdventOfCode.Solutions.Y25.Day09 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn input ->
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> then(fn [h1, h2 | []] -> {h1, h2} end)
    end)

    # |> MapSet.new()
  end

  defp generate_pairs(init, result) do
    case init do
      [] ->
        result

      [h | t] ->
        generate_pairs(t, Enum.map(t, fn i -> {h, i} end) ++ result)
    end
  end

  defp generate_areas(point_list) do
    point_list
    |> generate_pairs([])
    |> Enum.map(fn {p1, p2} -> {calculate_area(p1, p2), p1, p2} end)
  end

  defp calculate_area({x1, y1}, {x2, y2}) do
    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  def part_one(problem) do
    problem
    |> generate_areas()
    |> Enum.max_by(fn {area, _p1, _p2} -> area end)
    |> elem(0)
  end

  # def part_two(problem) do
  #   problem
  # end
end
