defmodule AdventOfCode.Solutions.Y23.Day04 do
  alias AoC.Input

  defp my_parse_line_function(line) do
    [card_label, numbers] = String.split(line, ": ")
    [_card, number] = String.split(card_label, " ") |> Enum.filter(fn x -> x != "" end)
    [left, right] = String.split(numbers, "|")

    %{
      id: String.to_integer(number),
      left: left |> String.split() |> Enum.map(&String.to_integer/1),
      right: right |> String.split() |> Enum.map(&String.to_integer/1)
    }
  end

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&my_parse_line_function/1)
  end

  defp custom_pow(0), do: 0
  defp custom_pow(n), do: :math.pow(2, n - 1)

  def part_one(problem) do
    # se mapea cada Card a la cantidad de elementos en común que tienen las listas
    # se hace el map con la función de 2^(cantidad-1)
    # se hace la suma

    problem
    |> Enum.map(fn %{left: winners, right: mine} ->
      Enum.filter(mine, fn x ->
        x in winners
      end)
      |> Enum.count()
      |> then(fn count -> custom_pow(count) end)
    end)
    |> Enum.sum()
  end

  defp proccess_elements([], results), do: results |> Map.values() |> Enum.sum()

  defp proccess_elements([h | t], results) do
    curr_repts = Map.get(results, h.id, 0)

    range =
      case matching_amount = h.matching do
        0 -> ..
        _ -> (h.id + 1)..(h.id + matching_amount)
      end

    proccess_elements(
      t,
      Enum.reduce(range, results, fn id, acc ->
        Map.update(acc, id, 0, fn val -> val + curr_repts end)
      end)
    )
  end

  def part_two(problem) do
    # mapa con una copia base de las cards

    # base_copy: %{id: id_card, matching: cantidad de elementos en común}
    base_copy =
      problem
      |> Enum.map(fn content ->
        %{
          id: content.id,
          matching:
            Enum.filter(content.left, fn x ->
              x in content.right
            end)
            |> Enum.count()
        }
      end)

    proccess_elements(
      base_copy,
      Enum.reduce(problem, %{}, fn %{id: id}, acc -> Map.put(acc, id, 1) end)
    )
  end
end
