defmodule AdventOfCode.Solutions.Y23.Day05 do
  alias AoC.Input

  @mapping_order [
    :seed_to_soil,
    :soil_to_fertilizer,
    :fertilizer_to_water,
    :water_to_light,
    :light_to_temperature,
    :temperature_to_humidity,
    :humidity_to_location
  ]

  def parse(input, _part) do
    Input.stream!(input, trim: true)
    |> Enum.reduce({%{}, nil}, fn
      # se ignoran las líneas vacías
      "", {acc, current_key} ->
        {acc, current_key}

      line, {acc, current_key} ->
        if String.ends_with?(line, ":") do
          # Nueva sección que no es seeds
          key =
            line
            |> String.trim_trailing(":")
            |> String.replace(" map", "")
            |> String.replace("-", "_")
            |> String.to_atom()

          {acc, key}
        else
          if current_key do
            # convertir las líneas de números en mapas que significan cosas
            numbers =
              line
              |> String.split()
              |> Enum.map(&String.to_integer/1)

            [destination, source, range] = numbers

            map = %{
              source: source..(source + range - 1),
              destination: destination..(destination + range - 1)
            }

            updated_acc =
              Map.update(acc, current_key, [map], fn existing -> existing ++ [map] end)

            {updated_acc, current_key}
          else
            # aquí es donde se supone que llega con seeds, creo
            seeds =
              line
              |> String.split(":")
              |> Enum.at(1)
              |> String.split()
              |> Enum.map(&String.to_integer/1)

            {Map.put(acc, :seeds, seeds), current_key}
          end
        end
    end)
    |> elem(0)
  end

  defp single_source_to_dest_part1(first_dest.._last_dest//_, first_source..last_source//_, seed) do
    case first_source <= seed and seed <= last_source do
      true -> first_dest + seed - first_source
      false -> nil
    end
  end

  defp source_to_dest_part1(specs, seed) do
    # [%{source, dest, range}]
    Enum.reduce(specs, nil, fn %{source: source, destination: dest}, acc ->
      case acc do
        nil ->
          single_source_to_dest_part1(dest, source, seed)

        value ->
          value
      end
    end)
    |> then(fn result ->
      case result do
        nil -> seed
        v -> v
      end
    end)
  end

  def part_one(problem) do
    # Voy a asumir que conozco la estructura de datos y definir el orden de ejecución de las claves
    problem.seeds
    |> Enum.map(fn seed ->
      Enum.reduce(@mapping_order, seed, fn key, acc ->
        source_to_dest_part1(Map.fetch!(problem, key), acc)
      end)
    end)
    |> Enum.min()
  end

  # seed es un rango de semillas
  defp map_seeds(
         first_source..last_source//_ = source,
         first_dest.._last_dest//_ = _dest,
         first_seed..last_seed//_ = seeds,
         %{ok: ok_list, pending: pending_list} = acc
       ) do
    cond do
      last_source < first_seed or last_seed < first_source ->
        # no hay ninguna semilla en el rango origen
        %{acc | pending: [seeds | pending_list]}

      first_source <= first_seed and last_seed <= last_source ->
        # todas las semillas están en el rango origen
        %{acc | ok: [Range.shift(seeds, first_dest - first_source) | ok_list]}

      first_source <= first_seed and first_seed <= last_source and last_source <= last_seed ->
        # el source empieza antes que las semillas y termina en medio de ellas
        # el source empieza a la vez que las semillas y termina en medio
        # source == first_seed
        %{
          acc
          | ok: [Range.shift(first_seed..last_source, first_dest + first_source) | ok_list],
            pending: [(last_source + 1)..last_seed | pending_list]
        }

      first_seed <= first_source and first_source <= last_seed and last_seed <= last_source ->
        # el source empieza en medio de las semillas y termina después de ellas
        # el source empieza en medio de las semillas y termina a la vez
        # source == last_seed
        %{
          acc
          | ok: [Range.shift(first_source..last_seed, first_dest - first_source) | ok_list],
            pending: [first_seed..(first_source - 1) | pending_list]
        }

      first_seed < first_source and last_source < last_seed ->
        # el source está en medio de las semillas
        %{
          acc
          | ok: [Range.shift(source, first_dest - first_source) | ok_list],
            pending: [
              first_seed..(first_source - 1),
              (last_source + 1)..last_seed | pending_list
            ]
        }

      true ->
        IO.inspect({seeds, source}, label: "unhandled case {seeds, source}")
        :error
    end
  end

  # specs es una lista de mapas con info y seed_range es un rango de semillas
  defp source_to_dest(specs, seed_range) do
    Enum.reduce(specs, %{ok: [], pending: []}, fn %{source: source, destination: dest}, acc ->
      case acc do
        %{ok: [], pending: []} ->
          # caso inicial
          map_seeds(source, dest, seed_range, acc)

        %{pending: pendings} ->
          Enum.reduce(pendings, %{ok: acc.ok, pending: []}, fn pending, acc2 ->
            map_seeds(source, dest, pending, acc2)
          end)

        :error ->
          # error
          :error
      end
    end)
    |> Enum.map(fn {_k, v} -> v end)
    |> List.flatten()
  end

  def part_two(problem) do
    seeds =
      problem.seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> a..(a + b - 1) end)

    seeds
    |> Enum.flat_map(fn seed_range ->
      Enum.reduce(@mapping_order, [seed_range], fn key, ranges ->
        Enum.flat_map(ranges, &source_to_dest(problem[key], &1))
      end)
    end)
    |> Enum.map(fn first.._last//_ -> first end)
    |> Enum.min()
  end
end
