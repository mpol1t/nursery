defmodule Nursery.Utils do
  @moduledoc """
  The `Nursery.Utils` module provides utility functions for filtering 
  child process specifications based on the environment.
  """

 @doc """
  Filters the list of child process specifications based on the provided environment.

  If the `envs` field is `:all`, the child process will always be included. If `envs` is a list,
  the child process will only be included if the current environment is in that list,
  unless `:all` is a member. Additionally, inserts empty config list if one is missing
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
  @spec filter_by_env([module: module(), config: any(), envs: atom() | [atom(), ...]], atom()) :: [keyword()]
  def filter_by_env(specs, env) do
    check_format(specs)
    |> Enum.filter(& env_filter(&1[:envs], env))
    |> Enum.map(&format_spec/1)
  end

  defp env_filter(:all,  _env),                    do: true
  defp env_filter(envs,   env) when is_list(envs), do: :all in envs or env in envs
  defp env_filter(envs,  _env)                     do
    raise ArgumentError, "Invalid value for :envs in spec #{inspect(envs)}. It must be either :all or a list of environments."
  end

  defp format_spec([module: m, config: c, envs: _]), do: {m, c}
  defp format_spec([module: m,            envs: _]), do: {m, []}

  defp check_format(specs) do
    Enum.each(specs, fn spec ->
      unless Keyword.has_key?(spec, :module) and Keyword.has_key?(spec, :envs) do
        raise ArgumentError, "Invalid child spec format for #{inspect(spec)}. Spec must include keys :module and :envs."
      end
    end)
    specs
  end
end
