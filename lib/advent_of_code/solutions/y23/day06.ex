defmodule AdventOfCode.Solutions.Y23.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
  end

  defp map_ways_to_win(%{time: t, distance: d}) do
    1..(Float.floor(t / 2) |> trunc())
    |> Enum.find(fn i ->
      # si la distancia para este i es mayor que d, es válido
      i * (t - i) > d
    end)
    |> then(fn result -> t - 1 - (result - 1) * 2 end)
  end

  defp my_parse_line_function_part1(input) do
    [time_line, distance_line] =
      input
      |> String.split("\n", trim: true)

    times =
      time_line
      |> String.split(":", parts: 2)
      |> List.last()
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    distances =
      distance_line
      |> String.split(":", parts: 2)
      |> List.last()
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    Enum.zip(times, distances)
    |> Enum.map(fn {t, d} -> %{time: t, distance: d} end)
  end

  def part_one(problem) do
    problem
    |> my_parse_line_function_part1()
    |> Enum.map(&map_ways_to_win/1)
    |> Enum.product()
  end

  defp my_parse_line_function_part2(input) do
    [time_line, distance_line] =
      input
      |> String.split("\n", trim: true)

    time =
      time_line
      |> String.split(":", parts: 2)
      |> List.last()
      |> String.replace(" ", "")
      |> String.to_integer()

    distance =
      distance_line
      |> String.split(":", parts: 2)
      |> List.last()
      |> String.replace(" ", "")
      |> String.to_integer()

    %{time: time, distance: distance}
  end

  def part_two(problem) do
    problem
    |> my_parse_line_function_part2()
    |> map_ways_to_win()
  end
end
