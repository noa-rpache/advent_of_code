defmodule AdventOfCode.Solutions.Y25.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  # @spec index_of_element([String.t()]) :: [number()]
  defp index_of_split(list) do
    list
    |> Enum.with_index()
    |> Enum.filter(fn {n, _i} -> n == "^" end)
    |> Enum.map(fn {_n, i} -> i end)
  end

  defp move_beam(_beam = {row, col}), do: {row + 1, col}

  defp split_beam(_beam = {row, col}), do: {{row + 1, col - 1}, {row + 1, col + 1}}

  def part_one(_problem = [h | t]) do
    initial_beam =
      Enum.find_index(h, &(&1 == "S"))
      |> then(fn v -> {0, v} end)

    t
    |> Enum.reduce({0, [initial_beam], 0}, fn row, acc = {row_index, beams, split_times} ->
      # IO.inspect(beams, label: "beams")

      splits =
        index_of_split(row)
        |> Enum.map(fn split_col -> {row_index, split_col} end)

      # |> IO.inspect(label: "index_of_split")

      {next_beams, new_splits} =
        beams
        |> Enum.reduce({[], 0}, fn beam, _result = {next_beams, split_counter} ->
          if Enum.any?(splits, &(&1 == beam)) do
            {b1, b2} = split_beam(beam)

            {[b1, b2 | next_beams], split_counter + 1}
            # |> IO.inspect(label: "beam splited")

            # si coincide se dividen las beams y se aumenta el contador de splits
          else
            # y si no pues se avanzan las beams donde están
            {[move_beam(beam) | next_beams], split_counter}
            # |> IO.inspect(label: "beam non splited")
          end
        end)

      {row_index + 1, Enum.uniq(next_beams), split_times + new_splits}
      # |> IO.inspect(label: "iteration")
    end)
    |> elem(2)
  end

  # def part_two(problem) do
  #   problem
  # end
end
