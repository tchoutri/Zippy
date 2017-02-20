defmodule Zippy.ZBinTreeTest do
  use ExUnit.Case, async: true
  import Zippy.ZBinTree
  

  setup_all(_) do
  {[],
  {:fork, :a,
    {:fork, :b, nil, nil},
    {:fork, :c, nil,
      {:fork, :d, nil, nil}
    }
  }
}
  end

  test "root/1", _ do
    assert root(:a) == {[], {:fork, :a, nil, nil}} 
  end

  test "current/1", ztree do
    assert current(root(:a)) == {:ok, :a}
    assert ztree |> right |> current == {:ok, :c}
  end

  test "replace/2", ztree do
    assert root(:a) |> replace(:c) |> current == {:ok, :c}
    assert ztree |> right |> replace(:f) |> current == {:ok, :f}
    assert ztree |> left |> left |> replace(:z) |> current == {:ok, :z} 

    assert ztree |> left |> left |> replace(:z) |> top |> top ==
      {[],
        {:fork, :a,
          {:fork, :b, {:fork, :z, nil, nil}, nil},
          {:fork, :c, nil, 
            {:fork, :d, nil, nil}
          }
        }
      }

  end

  test "right/1", ztree do
    assert right(ztree) ==
      {[{:right, :a, {:fork, :b, nil, nil}}], {:fork, :c, nil, {:fork, :d, nil, nil}}}

    assert ztree |> right |> right |> right == {_, nil}

    assert ztree |> right |> right |> right |> right == nil
  end

  test "left/1", ztree do
    assert left(ztree) ==
      {[{:left, :a, {:fork, :c, nil, {:fork, :d, nil, nil}}}], {:fork, :b, nil, nil}}
    assert ztree |> left |> left == {_, nil}
    assert ztree |> left |> left |> left nil
  end

  test "up/1", ztree do
    assert up(ztree) == nil
    assert ztree |> left |> up == ztree
  end
end
