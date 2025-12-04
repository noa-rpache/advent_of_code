defmodule AdventOfCode.Solutions.Y25.Day04 do
  alias AoC.Input

  @max_paper_rolls 4
  @paper_roll "@"
  @typep pos :: {number(), number()}

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
    # añade índice de fila
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_idx} ->
      row
      |> String.graphemes()
      # añade índice de columna
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {@paper_roll, col_idx} ->
          # posición encontrada
          [{row_idx, col_idx}]

        _ ->
          []
      end)
    end)
  end

  @spec adyacent_to_pos(pos(), pos()) :: boolean
  defp adyacent_to_pos({row1, col1} = pos1, {row2, col2} = pos2) do
    cond do
      pos1 == pos2 ->
        false

      (row2 == row1 - 1 or row2 == row1 or row2 == row1 + 1) and
          (col2 == col1 - 1 or col2 == col1 or col2 == col1 + 1) ->
        true

      true ->
        false
    end
  end

  def part_one(problem) do
    problem
    # |> IO.inspect()
    |> Enum.reduce({problem, []}, fn x, {full_list, acc} = full_acc ->
      len =
        Enum.filter(full_list, &adyacent_to_pos(&1, x))
        # |> IO.inspect(label: "adyacents to #{inspect(x)}")
        |> length()

      cond do
        len < @max_paper_rolls -> {full_list, [x | acc]}
        true -> full_acc
      end
    end)
    |> elem(1)
    |> Enum.uniq()
    |> length()

    # |> IO.inspect()
  end

  # def part_two(problem) do
  #   problem
  # end
end
