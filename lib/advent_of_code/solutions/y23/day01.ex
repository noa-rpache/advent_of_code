defmodule AdventOfCode.Solutions.Y23.Day01 do
  alias AoC.Input

  defp parse_line(line) do
    String.trim(line)
  end

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  def part_one(calibrations) do
    calibrations
    |> Enum.map(&to_string/1)
    |> Enum.map(&first_last_digit/1)
    |> Enum.sum()
  end

  defp first_last_digit(line) do
    line = to_string(line)
    digits = Regex.scan(~r/\d/, line) |> List.flatten()

    case digits do
      [] ->
        0

      [single] ->
        String.to_integer(single <> single)

      ds ->
        first = hd(ds)
        last = List.last(ds)
        String.to_integer(first <> last)
    end
  end

  def part_two(lines) do
    Enum.map(lines, &extract_digits/1)
    |> Enum.map(&first_last_digit/1)
    |> Enum.sum()
  end

  @digit_words ~w(one two three four five six seven eight nine)
  defp extract_digits(line) do
    # Regex con lookahead para capturar palabras solapadas o dígitos
    Regex.scan(~r/(?=(#{Enum.join(@digit_words, "|")}|\d))/, line)
    |> Enum.map(fn [_, token] -> normalize_digit(token) end)
  end

  defp normalize_digit("one"), do: "1"
  defp normalize_digit("two"), do: "2"
  defp normalize_digit("three"), do: "3"
  defp normalize_digit("four"), do: "4"
  defp normalize_digit("five"), do: "5"
  defp normalize_digit("six"), do: "6"
  defp normalize_digit("seven"), do: "7"
  defp normalize_digit("eight"), do: "8"
  defp normalize_digit("nine"), do: "9"
  defp normalize_digit(digit), do: digit
end
