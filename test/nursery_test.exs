defmodule NurseryTest do
  use ExUnit.Case
  use ExUnitProperties

  doctest Nursery

  alias Nursery.Utils
  alias Test.Support.Generators, as: Gen

  describe "Utils.filter_by_env/2" do
    test "includes children with :all envs" do
      specs = [
        [module: Foo, config: [a: 1], envs: :all],
        [module: Bar,                 envs: [:prod]]
      ]

      assert [{Foo, [a: 1]}] = Utils.filter_by_env(specs, :dev)
    end

    test "correctly handles :spec format" do
      child_spec = Supervisor.child_spec({Agent, fn -> 0 end}, id: :agent_a)
      specs      = [
        [spec: child_spec, envs: [:dev]],
      ]

      assert [^child_spec] = Utils.filter_by_env(specs, :dev)
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

    property "raises ArgumentError when spec format is invalid" do
      check all spec <- StreamData.list_of(
        StreamData.keyword_of(StreamData.integer()),
        min_length: 1,
        max_length: 5
      ) do
        assert_raise ArgumentError, ~r/Invalid child spec format for/, fn ->
          Enum.map(spec, & Keyword.drop(&1, [:module, :envs])) |> Utils.filter_by_env(:dev)
        end
      end
    end

    property "defaults to empty list when config argument is missing" do
      check all spec <- StreamData.list_of(
        StreamData.fixed_list(
          [
            StreamData.tuple({StreamData.constant(:module), StreamData.atom(:alphanumeric)}),
            StreamData.tuple({StreamData.constant(:envs),   StreamData.constant(:all)})
          ]
        )
      ) do
        assert Utils.filter_by_env(spec, :dev) |> Enum.all?(fn x -> elem(x, 1) == [] end)
      end
    end

    property "raises ArgumentError when envs argument is invalid" do
      check all spec <- StreamData.list_of(
        StreamData.fixed_list(
          [
            StreamData.tuple({StreamData.constant(:module), StreamData.atom(:alphanumeric)}),
            StreamData.tuple({StreamData.constant(:envs),   StreamData.integer()})
          ]
        ),
        min_length: 1
      ) do
        assert_raise ArgumentError, ~r/Invalid value for :envs/, fn ->
          Utils.filter_by_env(spec, :dev)
        end
      end
    end

    defp filter_envs_oracle(specs, env) do
      for spec <- specs,
          envs = Keyword.get(spec, :envs),
          envs == :all or :all in envs or env in envs do
        if Keyword.has_key?(spec, :spec) do
          Keyword.get(spec, :spec)
        else
          {Keyword.get(spec, :module), Keyword.get(spec, :config, [])}
        end
      end
    end

    property "correctly filters modules for a given environment" do
      check all env   <- StreamData.one_of([:prod, :dev, :test]),
                specs <- Gen.specs_generator() do
        assert filter_envs_oracle(specs, env) == Utils.filter_by_env(specs, env)
      end 
    end
  end
end
