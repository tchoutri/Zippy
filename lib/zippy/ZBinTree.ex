defmodule Zippy.ZBinTree do
  @moduledoc """
  This module implements Zipper binary trees, that allow you to traverse them in two directions.  

  This module is a port of Fred Hebert's [“Zippers”](https://github.com/ferd/zippers) library, under the MIT licence.
  """
  
  alias __MODULE__

  ## Type declarations

  @typep node(a) :: nil
                 | {:fork, a,  left::node(a), right::node(a)}

  @typep choice(a) :: {:left, a, node(a)}
                   | {:right, a, node(a)}

  @typep thread(a) :: [choice(a)]

  @typedoc "A Zipper binary tree"
  @type  t() :: {thread(any()), node(any())}

  ## Functions
  
  @doc "Create a new basic binary tree. It should be declared first when declaring the data structure."
  @spec root(term()) :: ZBinTree.t
  def   root(a) do
    {[], {:fork, a, nil, nil}}
  end

  @doc "Checks if a node is a leaf, that is to say if it has no child."
  @spec leaf?(ZBinTree.t) :: boolean()
  def   leaf?({_thread, {:fork, _, nil, nil}}), do: true
  def   leaf?({_thread, {:fork, _, _, _}}),       do: false

  @doc "Returns the current element in the binary tree in a tuple."
  @spec current(ZBintTree.t) :: {:ok, term()} | {:error, nil}
  def   current({_thread, {:fork, value, _left, _right}}), do: {:ok, value}
  def   current({_thread, nil}),                          do: {:error, nil}

  @doc "Replaces the current element in the tree (if it exists) or create a new node (if it doesn't)."
  @spec replace(ZBinTree.t, term()) :: ZBinTree.t
  def   replace(value, {thread, nil}),                            do: {thread, {:fork, value, nil, nil}}
  def   replace(value, {thread, {:fork, _oldvalue, left, right}}), do: {thread, {:fork, value, left, right}}

  @doc "Goes down the tree, with the `current` element being the `right` child."
  @spec right(ZBinTree.t) :: ZBinTree.t | nil
  def   right({thread, {:fork, value, left, right}}), do: {[{:right, value, left}|thread], right}
  def   right({_thread, nil}),                       do: nil

  @doc "Goes down the tree, with the `current` element being the `left` child, or returns `nil` if there is no child"
  @spec left(ZBinTree.t) :: ZBinTree.t | nil
  def   left({thread, {:fork, value, left, right}}), do: {[{:left, value, right}|thread], left}
  def   left({_thread, nil}),                          do: nil

  @doc "Goes up the tree, or returns `nil` if we're already at the top of the tree."
  @spec up(ZBinTree.t) :: ZBinTree | nil
  def   up({[{:left,  value, right}|thread], left}),  do: {thread, {:fork, value, left, right}}
  def   up({[{:right, value, left} |thread], right}), do: {thread, {:fork, value, left, right}}
  def   up({[], _tree}),                              do: nil

  @doc "Adds a left child to the tree"
  @spec add_left(ZBinTree.t, term()) :: ZBinTree.t
  def   add_left(new_branch, zipper) do
    new_branch
    |> replace(left(zipper))
    |> up
  end

  @spec add_right(ZBinTree.t, term()) :: ZBinTree.t
  def   add_right(new_branch, zipper) do
    new_branch
    |> replace(right(zipper))
    |> up
  end
end
