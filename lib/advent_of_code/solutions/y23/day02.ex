defmodule AdventOfCode.Solutions.Y23.Day02 do
  alias AoC.Input

  @red_cubes 12
  @green_cubes 13
  @blue_cubes 14

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [game, rest] = String.split(line, ": ")
      game_id = game |> String.replace("Game ", "") |> String.to_integer()

      rounds = String.split(rest, "; ")

      # mapa de rondas: %{1 => %{red: .., green: .., blue: ..}, 2 => ...}
      round_map =
        rounds
        |> Enum.with_index(1)
        |> Enum.reduce(%{}, fn {round, r_id}, acc_rounds ->
          counts =
            round
            |> String.split(", ")
            |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn part, acc3 ->
              [n, color] = String.split(part, " ")
              Map.update!(acc3, String.to_atom(color), &(&1 + String.to_integer(n)))
            end)

          Map.put(acc_rounds, r_id, counts)
        end)

      Map.put(acc, game_id, round_map)
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.filter(fn {_id_partida, partida} ->
      # que haya alguna ronda en la que se muestre más que el máximo de un color
      not Enum.any?(partida, fn {_id_ronda, ronda} ->
        ronda.blue > @blue_cubes or ronda.green > @green_cubes || ronda.red > @red_cubes
      end)
    end)
    |> Enum.map(fn {clave, _valor} -> clave end)
    |> Enum.sum()
  end

  def part_two(problem) do
    # calcular el número mínimo de cubos que hacen falta para que la partida sea posible
    # multiplicar esas cantidades para cada partida
    # sumar esos resultados de la multiplicación
    problem
    |> Enum.map(fn {_id, partida} ->
      partida
      |> Enum.reduce(%{:red => 0, :blue => 0, :green => 0}, fn {_id_r,
                                                                %{red: r, blue: b, green: g}},
                                                               acc ->
        %{
          red: max(r, acc.red),
          blue: max(b, acc.blue),
          green: max(g, acc.green)
        }
      end)
    end)
    |> Enum.map(fn partida -> partida.red * partida.blue * partida.green end)
    |> Enum.sum()
  end
end
