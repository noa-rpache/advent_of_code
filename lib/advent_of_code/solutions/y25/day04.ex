defmodule AdventOfCode.Solutions.Y25.Day04 do
  alias AoC.Input

  @max_paper_rolls 4
  @paper_roll "@"
  @typep pos :: {number(), number()}

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_idx} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {@paper_roll, col_idx} -> [{row_idx, col_idx}]
        _ -> []
      end)
    end)
  end

  @spec adyacent_to_pos(pos(), pos()) :: boolean
  defp adyacent_to_pos({row1, col1} = pos1, {row2, col2} = pos2) do
    # Si quieres medir esto (puede ser muchísimo), descomenta:
    # t0 = System.monotonic_time()

    result =
      cond do
        pos1 == pos2 ->
          false

        (row2 == row1 - 1 or row2 == row1 or row2 == row1 + 1) and
            (col2 == col1 - 1 or col2 == col1 or col2 == col1 + 1) ->
          true

        true ->
          false
      end

    # t1 = System.monotonic_time()
    # IO.puts("adyacent_to_pos -> #{t1 - t0} ns")

    result
  end

  @spec simplify_matrix([pos()]) :: {[pos()], number()}
  defp simplify_matrix(paper_rolls) do
    t0 = System.monotonic_time()

    result =
      paper_rolls
      |> Enum.reduce({paper_rolls, [], 0}, fn x, {full_list, acc, lenght_acc} = full_acc ->
        len =
          Enum.filter(full_list, &adyacent_to_pos(&1, x))
          |> length()

        if len < @max_paper_rolls do
          {full_list, [x | acc], lenght_acc + 1}
        else
          full_acc
        end
      end)
      |> then(fn {full_list, filtered_list, length_filtered} ->
        {Enum.reject(full_list, &(&1 in filtered_list)), length_filtered}
      end)

    t1 = System.monotonic_time()
    IO.puts("simplify_matrix -> #{(t1 - t0) / 1_000_000} ms")

    result
  end

  def part_one(problem) do
    problem
    |> simplify_matrix()
    |> elem(1)
  end

  @spec simplify_matrix_repeteadly([pos()]) :: number()
  defp simplify_matrix_repeteadly(problem) do
    t0 = System.monotonic_time()

    aux = fn aux, list, n ->
      {updated_list, amount} = simplify_matrix(list)

      if n == amount or amount == 0 do
        n + amount
      else
        aux.(aux, updated_list, n + amount)
      end
    end

    result = aux.(aux, problem, 0)

    t1 = System.monotonic_time()
    IO.puts("simplify_matrix_repeteadly -> #{(t1 - t0) / 1_000_000} ms")

    result
  end

  def part_two(problem) do
    problem
    |> simplify_matrix_repeteadly()
  end
end
