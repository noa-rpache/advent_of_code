defmodule AdventOfCode.Solutions.Y23.Day08 do
  alias AoC.Input

  @start_node "AAA"
  @finish_node "ZZZ"

  def parse(input, _part) do
    [instructions | rest] =
      Input.stream!(input, trim: true)
      |> Enum.to_list()

    graph =
      rest
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(fn line ->
        # "AAA = (BBB, CCC)"
        [node, targets] = String.split(line, " = ")

        [left, right] =
          targets
          |> String.trim_leading("(")
          |> String.trim_trailing(")")
          |> String.split(", ")

        {node,
         %{
           left: left,
           right: right,
           is_finish: String.ends_with?(node, "Z"),
           is_start: String.ends_with?(node, "A")
         }}
      end)
      |> Map.new()

    %{
      instructions: String.graphemes(instructions),
      graph: graph
    }
  end

  def part_one(problem) do
    nodes = problem.graph

    problem.instructions
    |> Stream.cycle()
    |> Enum.reduce_while({@start_node, 0}, fn instruction, {node_key, steps} ->
      case node_key do
        @finish_node ->
          {:halt, {node_key, steps}}

        _ ->
          {:cont,
           case instruction do
             "L" -> {nodes[node_key].left, steps + 1}
             "R" -> {nodes[node_key].right, steps + 1}
           end}
      end
    end)
    |> then(fn {_node, steps} -> steps end)
  end

  defp solve_single_path(problem, start_node) do
    nodes = problem.graph

    problem.instructions
    |> Enum.with_index()
    |> Stream.cycle()
    |> Enum.reduce_while({start_node, 0}, fn {instruction, index}, {node_key, steps} ->
      case nodes[node_key].is_finish do
        false ->
          {:cont,
           case instruction do
             "L" -> {nodes[node_key].left, steps + 1}
             "R" -> {nodes[node_key].right, steps + 1}
           end}

        true ->
          {:halt, {node_key, {steps, index}}}
      end
    end)
    |> then(fn {_node, result} -> result end)
  end

  def mcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end

  def mcm_list([head | tail]) do
    Enum.reduce(tail, head, &mcm(&2, &1))
  end

  def part_two(problem) do
    nodes =
      problem.graph

    start_nodes =
      nodes
      |> Enum.filter(fn {_k, v} -> v.is_start end)
      |> Enum.map(fn {k, _v} -> k end)

    # |> IO.inspect(label: "start nodes")

    start_nodes
    |> Enum.map(fn node ->
      {steps, _index} = solve_single_path(problem, node)
      steps
    end)
    |> Enum.to_list()
    |> mcm_list()

    # TODO la buena sería una función genérica que no dependiera de que se encuentre un finish_node justo al terminar las instrucciones
    # |> Enum.reduce(0, fn {steps, last_index} ->
    # end)
  end
end
