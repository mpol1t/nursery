[![codecov](https://codecov.io/gh/mpol1t/nursery/graph/badge.svg?token=bhkG0EYkWC)](https://codecov.io/gh/mpol1t/nursery)
[![Hex.pm](https://img.shields.io/hexpm/v/nursery.svg)](https://hex.pm/packages/nursery)
[![License](https://img.shields.io/github/license/mpol1t/nursery.svg)](https://github.com/mpol1t/nursery/blob/main/LICENSE)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/nursery)
[![Build Status](https://github.com/mpol1t/nursery/actions/workflows/elixir.yml/badge.svg)](https://github.com/mpol1t/nursery/actions)
[![Elixir Version](https://img.shields.io/badge/elixir-~%3E%201.16-purple.svg)](https://elixir-lang.org/)


# Nursery

**Nursery** is a lightweight Elixir library for supervising child processes based on the current environment (e.g., `:dev`, `:test`, `:prod`). The goal is to allow you to supervise and filter child processes in a way that's tailored to your application's environment.

This is particularly useful when you want to control which child processes are started in different environments, without cluttering your application logic.

## Installation

To use `Nursery`, simply add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nursery, "~> 0.1.2"}
  ]
end
```

Then run:

```sh
mix deps.get
```

## Usage

The `Nursery` module provides a macro that you can use in your application. This macro will set up the environment-aware supervisor for your child processes. 

### Example

Here’s how you can use the `Nursery` macro in your `application.ex`:

```elixir
defmodule MyApp do
  use Nursery, 
    app_name: :my_app,
    strategy: :one_for_one,
    children: [
      [module: Foo, config: [a: 1], envs: :all], # [:all] is also valid
      [module: Bar, config: [b: 2], envs: [:prod, :dev]],
      [module: Baz,                 envs: [:test]] # config is optional
    ]
end
```

Make sure to add `:environment` variable to your `config.exs` file:

```elixir
use Config

config :my_app,
  environment: config_env()
```

### How it works

- **`module`**: The child process module (e.g., `Foo`, `Bar`, etc.)
- **`config`**: Optional configuration that will be passed to the child process during startup.
- **`envs`**: The environments in which the child process should be included. If `:all` is specified, the child will be included in all environments.

The child processes will be filtered based on the environment of the application (as configured in your `config.exs` file). For example:
- `Foo` will be included in all environments because `envs: :all`.
- `Bar` will only be included in `:prod` and `:dev`.
- `Baz` will only be included in `:test`.

### Why `Nursery`?

`Nursery` helps you keep your application lightweight and elegant by ensuring that only the necessary child processes are started in the right environment. This can help optimize resource usage, simplify the supervision tree, and provide better control over your application's behavior in different environments.

## Contributing

Feel free to fork the project, submit issues, or create pull requests. Contributions are always welcome!

## License

MIT License. See `LICENSE` for more information.
