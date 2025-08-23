defmodule Test.Support.Generators do
  @moduledoc false

  use ExUnitProperties

  def env_generator do
    gen all env <- StreamData.one_of([:prod, :dev, :test, :all]) do
      env
    end
  end

  def envs_generator do
    gen all envs <- StreamData.one_of(
      [
        StreamData.uniq_list_of(env_generator(), min_length: 1, max_length: 2),
        StreamData.constant(:all)
      ]
    ) do
      envs
    end
  end

  def module_spec_generator_partial do
    gen all spec <- StreamData.fixed_list(
      [
        StreamData.tuple({StreamData.constant(:module), StreamData.atom(:alphanumeric)}),
        StreamData.tuple({StreamData.constant(:envs),   envs_generator()})
      ]
    ) do
      spec
    end
  end

  def module_spec_generator_complete do
    gen all spec <- StreamData.fixed_list(
      [
        StreamData.tuple({StreamData.constant(:module), StreamData.atom(:alphanumeric)}),
        StreamData.tuple({StreamData.constant(:config), StreamData.integer()}),
        StreamData.tuple({StreamData.constant(:envs),   envs_generator()})
      ]
    ) do
      spec
    end
  end

  def child_spec_generator do
    gen all id   <- StreamData.string(:alphanumeric, min_length: 5, max_length: 5),
            arg  <- StreamData.integer(),
            envs <- envs_generator() do
      [spec: Supervisor.child_spec({Agent, fn -> arg end}, id: id), envs: envs]
    end
  end

  def module_spec_generator do
    gen all spec <- StreamData.one_of(
      [
        module_spec_generator_partial(),
        module_spec_generator_complete(),
        child_spec_generator()
      ]
    ) do
      spec
    end
  end

  def specs_generator do
    gen all specs <- StreamData.uniq_list_of(module_spec_generator(), max_length: 10) do
      specs
    end
  end
end
