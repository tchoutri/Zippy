defmodule Zippy.ZForest do
  @moduledoc """
  Zipper forests are a zipper structure where each node is a list of
  subtrees.You can iterate over this structure, and thus represent a minimum spanning tree, a DOM, an undo tree, etc.  
  Adding, replacing and deleting operations are constant time.  

  This module is a port of Fred Hebert's [“Zippers”](https://github.com/ferd/zippers) library, under the MIT licence.
  """

  alias __MODULE__
  
  @typep zlist(a) :: {prev::list(a), next::list(a)}

  @typep znode()  :: zlist({term(), zlist(term())})

  @typep thread() :: [znode()]

  @typedoc "A Zipper forest"
  @type t()      :: {thread(), znode()}


  @doc "Create an empty zipper forest with `value` as its first element."
  @spec root(term()) :: ZForest.t
  def   root(value) do
    {[],
      {[],
        [{value,
           {[], []}
         }
        ]
      }
    }
  end

  @doc """
  Extract the node value from the current tree position as `{:ok, value}`.
  If there is no item, the function returns `{:error, nil}`
  """
  @spec value(ZForest.t) :: {:ok, term()} | {:error, nil}
  def   value({_thread, {_prev, []}}), do: {:error, nil}
  def   value({_thread, {_prev, [{value, _children}|_next]}}), do: {:ok, value}

  @doc "Replace the node at the `current` position with `value`."
  @spec replace(ZForest.t, term()) :: ZForest
  def   replace({thread, {left, right}}, value) do
    {thread,
      {left,
        [{value}, {[],[]} | right]
      }
    }
  end

  @doc "Insert a new node at the `current` position."
  @spec insert(ZForest.t, term) :: ZForest
  def   insert({thread, {left, right}}, value) do
    {thread, 
      {left,
        [{value, {[], []}} | right]
      }
    }
  end

  @doc "Delete the node at the `current position`. The next one on the right will take its place."
  @spec delete(ZForest.t) :: ZForest.t
  def   delete({thread, {left, [_|right]}}) do
    {thread, {left, right}}
  end

  @doc """
  Moves to the previous node from the `current` item.
  If we are already at the top, this function returns `nil`.
  """
  @spec prev(ZForest.t) :: ZForest.t | nil
  def   prev({_thread, {[], _next}}),    do: nil
  def   prev({thread,  {[h|t], right}})  do
    {thread, {t, [h|right]}}
  end

  @doc """
  Moves to the next node from the `current` item.
  If there is no next node, this function returns `nil`.
  """
  @spec next(ZForest.t) :: ZForest | nil
  def   next({_thread, {_prev, []}}),  do: nil
  def   next({thread,  {left, [h|t]}}) do
    {thread, {[h|left], t}}
  end

  @doc """
  Moves down the forest to the children of the `current` node.
  If we are already at the bottom, this function returns `nil`.
  """
  @spec down(ZForest.t) :: ZForest.t | nil
  def   down({_thread, {_left, []}}), do: nil
  def   down({thread, {left, [{value, children}|right]}}) do
    {
      [
        {left,
          [value|right]} | thread],
      children
    }
  end

  @doc """
  Moves up the forest to the parent of the `current` node, without rewinding the `current` node's child list.
  If we are already at the top, this function returns `nil`.
  """
  @spec up(ZForest.t) :: ZForest.t | nil
  def   up({[], _children}), do: nil
  def   up({[{left, [value|right]}|thread], children}) do
    {thread,
      {left,
        [{value, children}|right]
      }
    }
  end

  @doc """
  Moves up the forest to the parent of the `current` node, while rewinding the `current` node's child list.
  This allows the programmer to access children as it it were the first time, all the time.
  If we are already at the top, this function returns `nil`.
  """
  @spec rup(ZForest.t) :: ZForest.t | nil
  def   rup({[], _children}), do: nil
  def   rup({[{parent_left, [value|parent_right]}|thread], {left, right}}) do
    {thread,
      {parent_left,
        [{value, {[], Enum.reverse(left) ++ right}}|parent_right]
      }
    }
  end
end
