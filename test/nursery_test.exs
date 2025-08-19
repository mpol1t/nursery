defmodule NurseryTest do
  use ExUnit.Case
  doctest Nursery

  alias Nursery.Utils

  defmodule TestApp do
    use Nursery,
      app_name: :my_app,
      strategy: :one_for_one,
      children:
        [test_child_spec()]
        
    defp test_child_spec do
      [
        module: SomeModule,
        id: SomeModule,
        start: {SomeModule, :start_link, []},
        envs: [:dev]
      ]
    end
  end

  describe "Utils.for_env/2"  do
    test "includes children with :all envs" do
      specs = [
        [module: SomeModule, envs: :all],
        [module: AnotherModule, envs: [:prod]]
      ]

      result = Utils.for_env(specs, :dev)

      # The module with :all envs should always be included
      assert Enum.any?(result, fn {module, _config} -> module == SomeModule end)
    end

    test "includes children for matching environments" do
      specs = [
        [module: SomeModule, envs: [:dev, :test]],
        [module: AnotherModule, envs: [:prod]]
      ]

      result = Utils.for_env(specs, :dev)
    
      # The child with matching environments should be included
      assert Enum.any?(result, fn {module, _config} -> module == SomeModule end)
      assert Enum.filter(result, fn {module, _config} -> module == AnotherModule end) |> Enum.empty?()
    end

    test "raises error for invalid :envs value" do
      invalid_spec = [
        [module: SomeModule, envs: :invalid]
      ]

      assert_raise ArgumentError, ~r/Invalid value for :envs/, fn ->
        Utils.for_env(invalid_spec, :dev)
      end
    end
  end
end
