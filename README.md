# AdventOfCode

Para jugar a un día random:
```bash
mix aoc.set -y 2023 -d 3

mix aoc.create

xdg-open (mix aoc.url | grep 'https') # esta sintaxis es de fish, para bash con un $ delante del paréntesis

mix test

mix aoc.run
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `advent_of_code` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:advent_of_code, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/advent_of_code>.

