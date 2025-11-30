defmodule AdventOfCode.Solutions.Y23.Day07 do
  alias AoC.Input

  @hands_order [
    :high_card,
    # :one_pair_j,
    :one_pair,
    # :two_pair_j,
    :two_pair,
    # :three_of_a_kind_j,
    :three_of_a_kind,
    # :full_house_j,
    :full_house,
    # :four_of_a_kind_j,
    :four_of_a_kind,
    # :five_of_a_kind_j,
    :five_of_a_kind
  ]

  @cards_order_part_1 [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "T",
    "J",
    "Q",
    "K",
    "A"
  ]

  @cards_order_part_2 [
    "J",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "T",
    "Q",
    "K",
    "A"
  ]

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
  end

  defp apply_no_joker_rule(map) do
    case map_size(map) do
      1 ->
        :five_of_a_kind

      2 ->
        cond do
          Enum.find(map, fn {_k, v} -> v == 1 end) -> :four_of_a_kind
          # Enum.find(map, fn {_k, v} -> v == 2 end) -> :full_house
          true -> :full_house
        end

      3 ->
        cond do
          Enum.find(map, fn {_k, v} -> v == 3 end) -> :three_of_a_kind
          # Enum.find(map, fn {_k, v} -> v == 2 end) -> :two_pair
          true -> :two_pair
        end

      4 ->
        :one_pair

      5 ->
        :high_card

      _ ->
        IO.inspect("result for map #{inspect(map)} unhandled")
        :error
    end
  end

  defp apply_joker_rule(map) do
    # entrando aquí hay una de las claves que es J, sino se habría ido a las otras reglas
    case map_size(map) do
      1 ->
        :five_of_a_kind

      2 ->
        :five_of_a_kind

      3 ->
        cond do
          Enum.find(map, fn {k, v} -> v == 1 and k != "J" end) ->
            :four_of_a_kind

          Enum.find(map, fn {k, v} -> v == 2 and k != "J" end) ->
            :full_house

          true ->
            IO.inspect("result for map #{inspect(map)} unhandled")
            :error
        end

      4 ->
        cond do
          Enum.find(map, fn {k, v} -> v == 2 and k != "J" end) ->
            :three_of_a_kind

          Enum.find(map, fn {k, v} -> v == 2 and k == "J" end) ->
            :three_of_a_kind

          true ->
            IO.inspect("result for map #{inspect(map)} unhandled")
            :error
        end

      5 ->
        :one_pair

      _ ->
        # por aquí no debería de pasar, pero por si acaso
        IO.inspect("result for map #{inspect(map)} unhandled")
        :error
    end

    # |> IO.inspect(label: "apply_joker_rule result for map #{inspect(map)}")
  end

  defp get_hand_type(hand_og, joker_rule) do
    hand_og
    |> String.graphemes()
    |> Enum.frequencies()
    |> then(fn hand ->
      case joker_rule do
        false ->
          apply_no_joker_rule(hand)

        _ ->
          case String.contains?(hand_og, "J") do
            false -> apply_no_joker_rule(hand)
            _ -> apply_joker_rule(hand)
          end
      end
    end)
  end

  defp parse_line(line, joker_rule) do
    String.split(line, " ")
    |> (fn [hand, bid] ->
          %{
            hand: hand,
            bid: String.to_integer(bid),
            hand_type: get_hand_type(hand, joker_rule)
          }
        end).()
  end

  defp solve_problem(problem, cards_order, joker_rule \\ false) do
    problem
    |> Enum.map(&parse_line(&1, joker_rule))
    |> Enum.sort_by(fn hand ->
      card_indices =
        hand.hand
        |> String.graphemes()
        |> Enum.map(fn c -> Enum.find_index(cards_order, fn x -> x == c end) end)

      [Enum.find_index(@hands_order, fn x -> x == hand.hand_type end) | card_indices]
      |> List.to_tuple()
    end)
    |> Enum.with_index()
    # |> (fn x -> if joker_rule, do: IO.inspect(x, label: "sort_by results"); x end).()
    |> Enum.reduce(0, fn {hand, idx}, acc -> acc + hand.bid * (idx + 1) end)
  end

  def part_one(problem) do
    solve_problem(problem, @cards_order_part_1)
  end

  def part_two(problem) do
    solve_problem(problem, @cards_order_part_2, true)
  end
end
