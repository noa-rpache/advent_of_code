defmodule AdventOfCode.Utils.RangeMapSet do
  @moduledoc false

  defstruct ms: MapSet.new()

  @type t :: %__MODULE__{ms: MapSet.t()}

  def new(enumerable \\ []) do
    %__MODULE__{ms: MapSet.new(enumerable)}
  end

  defdelegate put(rms, term), to: MapSet
  defdelegate delete(rms, term), to: MapSet
  defdelegate union(r1, r2), to: MapSet
  defdelegate difference(r1, r2), to: MapSet
  defdelegate intersection(r1, r2), to: MapSet
  defdelegate size(rms), to: MapSet
  defdelegate to_list(rms), to: MapSet
  defdelegate equal?(r1, r2), to: MapSet
  defdelegate subset?(r1, r2), to: MapSet

  # member?/2 personalizado para soportar rangos
  def member?(%__MODULE__{ms: ms}, term) do
    Enum.any?(ms, fn
      %Range{} = r -> term in r
    end)
  end
end
