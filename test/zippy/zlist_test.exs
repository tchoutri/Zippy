defmodule Zippy.ZListTest do
  use ExUnit.Case, async: true
  alias Zippy.ZList, as: Z

  setup_all(_) do
    [
     enum:  Z.from_list([1,2,3,4]),
     empty: Z.new,
     mixed: Z.from_list([1,true, false, nil, [foo: :bar]])
    ]
  end

  test "reduce/2", context do
    assert Enum.reduce(context[:enum], fn(x, acc) -> x + acc end) == 10

    assert_raise Enum.EmptyError, fn ->
      Enum.reduce(Z.new, fn(x, acc) -> x + acc end) 
    end
  end

  test "member?/2", context do
    assert Enum.member?(context[:enum], 4)
    refute Enum.member?(context[:enum], 6)
  end

  test "count/1", context do
    assert Enum.count(context[:enum])  == 4
    assert Enum.count(context[:empty]) == 0
    assert Enum.count(context[:mixed]) == 5
  end

  test "next/1", context do
    assert Z.next(context[:mixed]) == {[1], [true, false, nil, [foo: :bar]]}
    assert Z.next(context[:empty]) == nil
  end

  test "prev/1", context do
    assert context[:mixed] |> Z.next |> Z.prev == context[:mixed]
    assert context[:mixed] |> Z.next |> Z.prev |> Z.prev == nil
  end

  test "current/1", context do
    assert Z.current(context[:mixed]) == {:ok, 1}
    assert  Z.current(Z.new)          == {:error, nil}
  end

  test "replace/2", context do
    assert Z.replace(context[:mixed], 10) == {[], [10, true, false, nil, [foo: :bar]]}
    assert Z.replace(context[:empty], 10) == {[], [10]}
  end

  test "insert/2", context do
    assert Z.insert(context[:mixed], 10) == {[], [10, 1, true, false, nil, [foo: :bar]]}
    assert Z.insert(Z.new, 10)           == {[], [10]}
  end

  test "delete/1", context do
    assert Z.delete(context[:mixed]) == {[], [true, false, nil, [foo: :bar]]}
    assert Z.delete(Z.new)           == nil
  end
end
