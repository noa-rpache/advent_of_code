defmodule AdventOfCode.Solutions.Y25.Day02 do
  require Integer
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split(",")
    |> Enum.map(fn input ->
      input
      |> String.replace("\n", "")
      |> String.split("-")
      |> then(fn [h1, h2 | _t] -> String.to_integer(h1)..String.to_integer(h2) end)
    end)
  end

  # esto te da los IDs no válidos en un rango
  defp proccess_single_range(_ini.._fin//_step = range) do
    range
    |> Enum.filter(fn e ->
      charlist = Integer.to_charlist(e)
      string = Integer.to_string(e)

      valid =
        cond do
          charlist |> length() |> then(fn len -> Integer.mod(len, 2) != 0 end) ->
            # IO.inspect(e, label: "charlist length")
            true

          charlist
          |> Enum.frequencies()
          |> Map.values()
          |> Enum.any?(fn len -> Integer.mod(len, 2) != 0 end) ->
            # IO.inspect(e, label: "map values")
            true

          Regex.match?(~r"^(.+)\1+$", string) ->
            # IO.inspect(e, label: "regex")
            false

          true ->
            # IO.inspect(e, label: "valid")
            true
        end

      not valid
    end)

    # |> IO.inspect(label: "range #{ini}..#{fin} result")
  end

  def part_one(problem) do
    problem
    |> Enum.map(&proccess_single_range/1)
    # |> IO.inspect(label: "problem")
    |> List.flatten()
    |> Enum.sum()
  end

  # esto te da los IDs no válidos en un rango
  defp proccess_single_range_part_two(_ini.._fin//_step = range) do
    range
    |> Enum.filter(fn e ->
      string = Integer.to_string(e)

      valid =
        cond do
          Regex.match?(~r"^(.+)\1+$", string) ->
            # IO.inspect(e, label: "regex")
            false

          true ->
            # IO.inspect(e, label: "valid")
            true
        end

      not valid
    end)

    # |> IO.inspect(label: "range #{ini}..#{fin} result")
  end

  def part_two(problem) do
    problem
    |> Enum.map(&proccess_single_range_part_two/1)
    # |> IO.inspect(label: "problem")
    |> List.flatten()
    |> Enum.sum()
  end
end
