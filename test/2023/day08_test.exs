defmodule AdventOfCode.Solutions.Y23.Day08Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day08, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 8
  #
  #     mix test test/2023/day08_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 8 --part 1
  #
  # Use sample input file:
  #
  #     # returns {:ok, "priv/input/2023/day-08-mysuffix.inp"}
  #     {:ok, path} = Input.resolve(2023, 8, "mysuffix")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example 1" do
    input = ~S"""
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """

    assert 2 == solve(input, :part_one)
  end

  test "part one example 2" do
    input = ~S"""
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

    assert 6 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 12083

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 8, :part_one)
  end

  test "part two example" do
    input = ~S"""
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    assert 6 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 13_385_272_668_829

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 8, :part_two)
  end
end
