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

  describe "Utils.filter_by_env/2" do
    test "includes children with :all envs" do
      specs = [
        [module: Foo, config: [a: 1], envs: :all],
        [module: Bar,                 envs: [:prod]]
      ]

      assert [{Foo, [a: 1]}] = Utils.filter_by_env(specs, :dev)
    end

    test "includes children with :all as a member of envs" do
      specs = [
        [module: Foo, config: [c: 3], envs: [:all]],
        [module: Bar, config: [d: 4], envs: [:prod]]
      ]

      assert [{Foo, [c: 3]}] = Utils.filter_by_env(specs, :dev)
    end

    test "includes children for matching environments" do
      specs = [
        [module: Foo, envs: [:dev, :test]],
        [module: Bar, envs: [:prod]]
      ]

      assert [{Foo, []}] = Utils.filter_by_env(specs, :dev)
    end

    test "raises error for invalid :envs value" do
      invalid_spec = [
        [module: Foo, envs: :invalid]
      ]

      assert_raise ArgumentError, ~r/Invalid value for :envs/, fn ->
        Utils.filter_by_env(invalid_spec, :dev)
      end
    end

    test "raises error for invalid spec format" do
      invalid_spec = [
        [modul: Foo, envs: :invalid]
      ]

      assert_raise ArgumentError, ~r/Invalid child spec format for/, fn ->
        Utils.filter_by_env(invalid_spec, :dev)
      end
    end

    test "includes children with :all envs even if empty list is passed" do
      specs = [
        [module: Foo, envs: :all],
        [module: Bar, envs: []]
      ]

      assert [{Foo, []}] = Utils.filter_by_env(specs, :dev)
    end

    test "includes children for multiple matching environments" do
      specs = [
        [module: Foo,                 envs: [:dev, :prod]],
        [module: Bar, config: [a: 5], envs: [:prod]]
      ]

      assert [{Foo, []}, {Bar, [a: 5]}] = Utils.filter_by_env(specs, :prod)
    end

    test "returns empty list when no spec matches the environment" do
      specs = [
        [module: Foo, envs: [:test]],
        [module: Bar, envs: [:prod]]
      ]

      assert [] = Utils.filter_by_env(specs, :dev)
    end

    test "returns empty list for empty specs" do
      assert [] = Utils.filter_by_env([], :dev)
    end
  end
end
