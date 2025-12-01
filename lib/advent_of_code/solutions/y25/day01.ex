defmodule AdventOfCode.Solutions.Y25.Day01 do
  alias AoC.Input

  @total_positions 100
  @start_position 50

  # el problema es:
  # _ = { L | R, {resto_del_módulo, cociente} }
  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x ->
      {dir, num} = String.split_at(x, 1)

      {dir,
       {String.to_integer(num) |> Integer.mod(@total_positions),
        (String.to_integer(num) / @total_positions) |> Float.floor()}}
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.reduce({@start_position, 0}, fn {instruction, {amount, _}}, {current_position, acc} ->
      next_position =
        case instruction do
          "R" -> Integer.mod(current_position + amount, @total_positions)
          "L" -> Integer.mod(current_position - amount, @total_positions)
          _ -> :error
        end

      case next_position do
        :error -> :error
        0 -> {next_position, acc + 1}
        _ -> {next_position, acc}
      end
    end)
    |> elem(1)
  end

  def part_two(problem) do
    problem
    # |> IO.inspect(label: "problem")
    |> Enum.reduce({@start_position, 0}, fn {instruction, {amount, other_amount}}, {current_position, acc} ->
      # calculamos la siguiente posición en la rueda
      next_position =
        case instruction do
          "L" -> Integer.mod(current_position - amount, @total_positions)
          "R" -> Integer.mod(current_position + amount, @total_positions)
          _ -> :error
        end
        # |> IO.inspect(label: "#{instruction} current_position: #{current_position} and nex_position")

      # calculamos las veces que pasó por el 0
      plus = cond do
        other_amount == 0 -> case instruction do
          "L" -> if next_position > current_position do 1 else 0 end
          "R" -> if next_position < current_position do 1 else 0 end
        end
        true -> other_amount
      end
      # |> IO.inspect(label: "plus")


      case next_position do
        :error -> :error
        # 0 -> {next_position, acc + 1 + plus}
        _ -> {next_position, acc + plus}
      end
    end)
    |> elem(1)
  end
end
