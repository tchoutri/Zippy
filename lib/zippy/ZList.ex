defmodule Zippy.ZList do
  @moduledoc """
  This module implements Zipper lists, that allow you to traverse them in two directions.
  The *current* element is not always the first one, and has a constant access time.  

  This module is a port of Fred Hebert's [“Zippers”](https://github.com/ferd/zippers) library, under the MIT licence.
  """

  alias __MODULE__

  @typedoc "A Zipper list"
  @type t :: {prev::list(), next::list()}


  @doc "This function creates an empty Zipper list."
  @spec new() :: ZList.t
  def   new, do: {[], []}

  @doc "This function imports a zipper list from a list."
  @spec from_list(list()) :: ZList.t
  def   from_list(l) when is_list(l) do
    {[], l}
  end

  @doc "This function exports a Zipper list to a simple list."
  @spec to_list(ZList.t) :: list()
  def   to_list({pre, post}) do
    Enum.reverse(pre) ++ post
  end

  @doc """
  This function accesses the previous element of the zipper list.
  If there is no previous element, it returns `nil`.
  """
  @spec prev(ZList.t) :: ZList.t | nil
  def   prev({[],  _post}), do: nil
  def   prev({[h|t], post}), do: {t, [h|post]}

  @doc """
  This function accesses the next element of the zipper list.
  If there is no next element, it returns `nil`.
  """
  @spec next(ZList.t) :: ZList.t | nil
  def   next({_pre,    []}), do: nil
  def   next({pre,  [h|t]}), do: {[h|pre], t}

  @doc """
  This function returns the `current` element of the zipper list."
  If the zipper is empty, then `nil` is returned.
  """
  @spec current(ZList.t) :: ZList.t | nil
  def   current({_, []}),          do: nil
  def   current({_, [current|_]}), do: current

  @doc "This function changes the value of the `current` list item."
  @spec replace(ZList.t, term()) :: ZList.t
  def   replace({pre, [_|post]}, value) do
    {pre, [value|post]}
  end

  @doc """
  This function inserts `value` at the `current` item position.
  However, when successively adding items, use `next/1` if you want
  to have an ordered Zipper
  """
  @spec insert(ZList.t, term()) :: ZList.t
  def   insert({pre, post}, value) do
    {pre, [value|post]}
  end

  @doc """
  This function deletes the item at the `current` position.
  """
  @spec delete(ZList.t) :: ZList.t
  def   delete({pre, [_|post]}) do
    {pre, post}
  end
end
