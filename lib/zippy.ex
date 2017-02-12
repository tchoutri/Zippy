defmodule Zippy do
  @moduledoc """
  Zippy is an implementation of the [Zippers](https://github.com/ferd/zippers/) erlang data structure by Fred Hebert.  
  Its three modules implement three different kind of zippers:

  * Zipper lists
  * Zipper binary trees
  * Zipper forests

  It differs from the original library in:

  * When returning an `{:ok, value}` tuple in case of success, functions will also return a `{:error, nil}` in case of failure.
  * All `:undefined` atoms have been replaced by `nil`, which I find more idiomatic.
  * Idiomatic function names (`if_leaf` ➜ `leaf?`) when needed.
  * Functions' first argument is the data structure, which allows chaining operations on it with the `|>` operator.
  """
end
