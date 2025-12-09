defmodule AdventOfCode.Solutions.Y25.Day08 do
  alias AoC.Input

  @closest_together_test 10
  @closest_together_run 1000

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn s ->
      [h1, h2, h3 | _t] = String.split(s, ",") |> Enum.map(&String.to_integer/1)
      {h1, h2, h3}
    end)
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt(
      :math.pow(x2 - x1, 2) +
        :math.pow(y2 - y1, 2) +
        :math.pow(z2 - z1, 2)
    )
  end

  defp generate_pairs(init, result) do
    case init do
      [] ->
        result

      [h | t] ->
        generate_pairs(t, Enum.map(t, fn i -> {h, i} end) ++ result)
    end
  end

  defp calculate_distances(boxes) do
    generate_pairs(boxes, [])
    |> Enum.map(fn {p1, p2} -> {distance(p1, p2), p1, p2} end)
    |> Enum.sort_by(fn {d, _p1, _p2} -> d end)
    |> IO.inspect(label: "distances")
    |> Enum.take(@closest_together_run)
  end

  defp member_of_a_circuit(circuit_list, box) do
    Enum.find(circuit_list, fn circuit ->
      MapSet.member?(circuit, box)
    end)
  end

  # [{316.90219311326956, {162, 817, 812}, {425, 690, 689}}], ie {distance, p1, p2}[]
  # result es una lista de MapSet, cada uno de ellos representa un circuito
  defp generate_circuits_rec(distances, circuits) do
    case distances do
      [] ->
        circuits

      _distances_list = [h_distances | t_distances] ->
        {_d, p1, p2} = h_distances

        case circuits do
          [] ->
            generate_circuits_rec(t_distances, [
              MapSet.new([p1, p2])
            ])

          circuits = [_circuit | _other_circuits] ->
            # result no es un MapSet, sino una lista de ellos
            contains_p1 = member_of_a_circuit(circuits, p1)
            contains_p2 = member_of_a_circuit(circuits, p2)

            cond do
              contains_p1 == nil and contains_p2 == nil ->
                generate_circuits_rec(t_distances, [MapSet.new([p1, p2]) | circuits])

              contains_p1 != nil and contains_p2 != nil ->
                new_circuits =
                  circuits
                  |> Enum.reject(&(&1 == contains_p1 or &1 == contains_p2))

                generate_circuits_rec(t_distances, [
                  MapSet.union(contains_p1, contains_p2) | new_circuits
                ])

              contains_p1 ->
                new_circuits =
                  circuits
                  |> Enum.reject(&(&1 == contains_p1))

                generate_circuits_rec(t_distances, [MapSet.put(contains_p1, p2) | new_circuits])

              contains_p2 ->
                new_circuits =
                  circuits
                  |> Enum.reject(&(&1 == contains_p2))

                generate_circuits_rec(t_distances, [MapSet.put(contains_p2, p1) | new_circuits])

              true ->
                :error
            end
        end
    end
  end

  defp generate_circuits(boxes) do
    generate_circuits_rec(boxes, [])
    |> Enum.sort_by(fn circuit -> MapSet.size(circuit) end, :desc)
    |> IO.inspect(label: "circuits")
    |> Enum.take(3)
  end

  def part_one(problem) do
    problem
    |> calculate_distances()
    |> IO.inspect(label: "filtered distances")
    |> generate_circuits()
    |> IO.inspect(label: "filteres circuits")
    |> Enum.reduce(1, fn circuit, result -> MapSet.size(circuit) * result end)
    |> IO.inspect(label: "result")
  end

  # def part_two(problem) do
  #   problem
  # end
end
