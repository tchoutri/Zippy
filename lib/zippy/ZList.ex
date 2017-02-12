defmodule Zippy.ZList do
  @moduledoc """
  This module implements Zipper lists, that allow you to traverse them in two directions.
  The *current* element is not always the first one, and has a constant access time.  

  This module is a port of Fred Hebert's [“Zippers”](https://github.com/ferd/zippers) library, under the MIT licence.
  """

  alias __MODULE__

  @typedoc "A Zipper list"
  @type t :: {prev::list(), next::list()}

  @spec new() :: ZList.t
  def new, do: {[], []}

  @spec from_list(list()) :: ZList.t
  def from_list(l) when is_list(l) do
    {[], l}
  end

  @spec to_list(ZList.t) :: list()
  def to_list({pre, post}) do
    Enum.reverse(pre) ++ post
  end

  @spec prev(ZList.t) :: ZList.t | nil
  def prev({[],  _post}), do: nil
  def prev({[h|t], post}), do: {t, [h|post]}

  @spec next(ZList.t) :: ZList.t | nil
  def next({_pre,    []}), do: nil
  def next({pre,  [h|t]}), do: {[h|pre], t}

  @spec current(ZList.t) :: ZList.t | nil
  def current({_, []}),          do: nil
  def current({_, [current|_]}), do: current

  @spec replace(ZList.t, term()) :: ZList.t
  def replace({pre, [_|post]}, value) do
    {pre, [value|post]}
  end

  @spec insert(ZList.t, term()) :: ZList.t
  def insert({pre, post}, value) do
    {pre, [value|post]}
  end

  @spec delete(ZList.t) :: ZList.t
  def delete({pre, [_|post]}) do
    {pre, post}
  end
end
