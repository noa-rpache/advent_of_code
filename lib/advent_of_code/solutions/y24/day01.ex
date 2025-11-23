defmodule AdventOfCode.Solutions.Y24.Day01 do
  alias AoC.Input

  defp parse_line(line) do
    case String.split(line) do
      [a, b] -> {String.to_integer(a), String.to_integer(b)}
    end
  end

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.unzip()
  end

  def part_one({lista1, lista2}) do
    {sorted1, sorted2} = {Enum.sort(lista1, &<=/2), Enum.sort(lista2, &<=/2)}

    Enum.zip(sorted1, sorted2)
    |> Enum.map(fn {x, y} -> Kernel.abs(x - y) end)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  def part_two({lista1, lista2}) do
    freqs = Enum.frequencies(lista2)

    Enum.map(lista1, fn x -> x * Map.get(freqs, x, 0) end)
    |> Enum.reduce(fn x, acc -> x + acc end)

    # también se podría hacer con la lógica del map en el reduce, pero creo que no cambia nada en tiempo porque ya lo debe de hacer el compilador
    # Enum.reduce(lista1, 0, fn x, acc ->
    #   acc + x * Map.get(freqs, x, 0)
    # end)
  end
end
