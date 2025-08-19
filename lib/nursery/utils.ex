defmodule Nursery.Utils do
  @moduledoc """
  The `Nursery.Utils` module provides utility functions for filtering 
  child process specifications based on the environment.
  """

 @doc """
  Filters the list of child process specifications based on the provided environment.

  If the `envs` field is `:all`, the child process will always be included.
  If `envs` is a list, the child process will only be included if the current 
  environment is in that list. Additionally, inserts empty config list if one is missing
  from the spec.

  ## Parameters:
    - `specs`: A list of child process specifications. Each specification is a keyword list
      where `:envs` specifies the environments in which the child process should be included.
    - `env`: The current environment (atom), which is used to filter the child processes.

  ## Returns:
    - A filtered list of child process specifications, with the module and configuration.

  ## Raises:
    - `ArgumentError`: If the `:envs` field in any spec is neither `:all` nor a valid list of environments.
  """
  @spec for_env([keyword()], atom()) :: [keyword()]
  def for_env(specs, env) do
    Enum.filter(specs, fn spec ->
      case Keyword.get(spec, :envs) do
        :all                    -> true         # Always include this spec if `envs` is `:all`
        envs when is_list(envs) -> env in envs  # Filter by the provided `envs` list
        _                       -> 
          raise ArgumentError, "Invalid value for :envs in spec #{inspect(spec)}. It must be either `:all` or a list of environments."
      end
    end)
    |> Enum.map(fn spec -> {spec[:module], Keyword.get(spec, :config, [])} end)  # Default to `[]` if `config` is missing
  end
end
