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
    {:nursery, "~> 0.2.1"}
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
    app_name:        :my_app,
    supervisor_name: MyApp.Sup,
    strategy:        :one_for_one,
    children: [
      [module: A, config: [a: 1],                          envs: :all],
      [module: B, config: [b: 1],                          envs: [:all]],
      [module: C, config: [c: 2],                          envs: [:prod, :dev]],
      [module: D,                                          envs: [:test]],
      [spec:   Supervisor.child_spec({E, [e: 3]}, id: :e), envs: [:test]]
    ]
end
```

Make sure to add the `:environment` variable to your `config.exs` file:

```elixir
use Config

config :my_app,
  environment: config_env() # Uses the environment defined by mix, i.e., :dev, :test, :prod
```

---

### How it works

- **`module`**: Specifies the child process module to be used (e.g., `A`, `B`, etc.). This will be the actual module that gets started under the supervisor.
- **`config`**: Optional configuration that will be passed to the child process when it starts. If no configuration is provided, the child will be started with an empty list (`[]`) by default.
- **`envs`**: Specifies which environments the child process will be included in. This can be:
  - `:all`: The child will be included in all environments (e.g., development, production, test).
  - A list of specific environments (e.g., `[:prod, :dev]`), where the child will only be included in those specified environments.
  
### Example Breakdown:

- `A`: Always included in all environments (`envs: :all`).
- `B`: Always included in all environments (`envs: [:all]`).
- `C`: Only included in `:prod` and `:dev` environments (`envs: [:prod, :dev]`).
- `D`: Only included in `:test` environment (`envs: [:test]`).
- `E`: This child uses `Supervisor.child_spec/2` to specify a custom child process specification and is included only in the `:test` environment (`envs: [:test]`).

This way, you can define child processes that are only started in specific environments, making it easier to configure different services based on the environment your application is running in.

### Why `Nursery`?

`Nursery` helps you keep your application lightweight and elegant by ensuring that only the necessary child processes are started in the right environment. This can help optimize resource usage, simplify the supervision tree, and provide better control over your application's behavior in different environments.

## Contributing

Feel free to fork the project, submit issues, or create pull requests. Contributions are always welcome!

## License

MIT License. See `LICENSE` for more information.
