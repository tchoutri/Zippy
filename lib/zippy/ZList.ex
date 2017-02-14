defmodule Zippy.ZList do
  @moduledoc """
  This module implements Zipper lists, that allow you to traverse them in two directions.
  The *current* element is not always the first one, and has a constant access time.  

  This module is a port of Fred Hebert's [“Zippers”](https://github.com/ferd/zippers) library, under the MIT licence.
  """

  alias __MODULE__

  @typedoc "A Zipper list"
  @type t :: {prev::list(), next::list()}

  defimpl Enumerable, for: Tuple do
    def reduce(zipper, acc, fun) do
      list = ZList.to_list zipper
      do_reduce(list, acc, fun)
    end

    defp do_reduce(_,     {:halt, acc},   _fun), do: {:halted, acc}
    defp do_reduce(list,  {:suspend, acc}, fun), do: {:suspended, acc, &reduce(list, &1, fun)}
    defp do_reduce([],    {:cont, acc},   _fun), do: {:done, acc}
    defp do_reduce([h|t], {:cont, acc},    fun), do: reduce(t, fun.(h, acc), fun)

    def member?({pre, post}, element) do
      cond do
        r = Enum.member?(pre, element)  -> {:ok, r}
        r = Enum.member?(post, element) -> {:ok, r}
        true -> {:error, __MODULE__}
      end
    end

    @spec count(ZList.t) :: {:ok, non_neg_integer()} | {:error, module}
    def   count(zipper), do: {:ok, length(ZList.to_list(zipper))}
  end


  @doc "This function creates an empty Zipper list."
  @spec new() :: ZList.t
  def   new, do: {[], []}

  @doc "This function imports a zipper list from a list."
  @spec from_list(list()) :: ZList.t
  def   from_list(l) when is_list(l) do
    {[], l}
  end

  @doc "This function exports a Zipper list to a simple list."
  def   to_list(zipper) do
    _to_list(zipper)
  end

  @spec to_list(ZList.t) :: list()
  @spec to_list(list())  :: list()
  defp _to_list({pre, post}), do: Enum.reverse(pre) ++ post
  defp _to_list(list) when is_list(list), do: list

  # @doc "invokes `fun` for each element of the zipper list, which for a matter of convenience, is exported as a list."
  # @spec reduce(ZList.t, (element(), any() -> any())) :: list()
  # def   reduce(zipper, fun) do
    
  # defp  do_reduce([], acc, fun),    do: acc
  # defp  do_reduce([h|t], acc, fun), do: do_reduce(t, fun.(h) ++ acc, fun)

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

  @doc """
  This function changes the value of the `current` list item.
  If an empty zipper list is passed, then the value is inserted as the `current` item.
  """
  @spec replace(ZList.t, term()) :: ZList.t
  def   replace({[], []}, value),        do: {[], [value]}
  def   replace({pre, [_|post]}, value), do: {pre, [value|post]}

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
  def   delete({[], []}),        do: nil
  def   delete({pre, [_|post]}), do: {pre, post}
end
