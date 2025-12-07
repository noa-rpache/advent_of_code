defmodule AdventOfCode.Solutions.Y25.Day06 do
  alias AoC.Input

  @plus_symbol "+"
  @multiply_symbol "*"

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
    |> Enum.map(&(String.split(&1, " ") |> Enum.reject(fn x -> x == "" end)))
  end

  @spec part_one([String.t()]) :: number()
  def part_one(problem) do
    # el objetivo es convertir cada una de las columnas en un mapa, donde hay un campo input, que es una lista de números, y un campo operation, que es la operación a realizar
    # # el objeto general es un mapa con clave el índice y valor la columna
    problem
    |> Enum.reduce(%{}, fn input, acc ->
      if(Enum.any?(input, fn i -> i == @plus_symbol || i == @multiply_symbol end)) do
        # es la fila con las operaciones, se añaden las operaciones a la columna correspondiente y se termina la pesca
        input
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {op, index}, acc ->
          acc
          |> Map.update(index, %{}, fn value_of_index ->
            Map.put(
              value_of_index,
              :operation,
              case op do
                @plus_symbol -> @plus_symbol
                @multiply_symbol -> @multiply_symbol
                _ -> :error
              end
            )
          end)
        end)
      else
        # es una fila con números, se añade cada cual a su apartado
        Enum.map(input, fn i ->
          String.to_integer(i)
        end)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {elem, index}, acc ->
          Map.update(acc, index, %{input: [elem]}, fn %{input: prev} ->
            %{input: [elem | prev]}
          end)
        end)
      end
    end)
    |> Enum.map(fn {_key, %{input: i, operation: op}} ->
      case op do
        @plus_symbol -> Enum.sum(i)
        @multiply_symbol -> Enum.product(i)
        _ -> :error
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  # def part_two(problem) do
  #   problem
  # end
end
