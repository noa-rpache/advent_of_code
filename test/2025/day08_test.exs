defmodule AdventOfCode.Solutions.Y25.Day08Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y25.Day08, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2025 --day 8
  #
  #     mix test test/2025/day08_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2025 --day 8 --part 1
  #
  # Use sample input file:
  #
  #     # returns {:ok, "priv/input/2025/day-08-mysuffix.inp"}
  #     {:ok, path} = Input.resolve(2025, 8, "mysuffix")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  # test "part one example" do
  #   input = ~S"""
  #   162,817,812
  #   57,618,57
  #   906,360,560
  #   592,479,940
  #   352,342,300
  #   466,668,158
  #   542,29,236
  #   431,825,988
  #   739,650,466
  #   52,470,668
  #   216,146,977
  #   819,987,18
  #   117,168,530
  #   805,96,715
  #   346,949,466
  #   970,615,88
  #   941,993,340
  #   862,61,35
  #   984,92,344
  #   425,690,689
  #   """

  #   assert 40 == solve(input, :part_one)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 63920

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 8, :part_one)
  end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2025, 8, :part_two)
  # end
end
