========================
Zippy |elixir| |license|
========================

Zippy is an Elixir implementation of Fred Hebert's Zippers_ erlang library.
The main motivation was of course to better grasp this kind of data structures, but I also added my own grain of salt in some parts:

* When returning an `{:ok, value}` tuple in case of success, functions will also return a `{:error, nil}` in case of failure.
* All `:undefined` atoms have been replaced by `nil`, which I find more idiomatic.
* Idiomatic function names (`if_leaf` → `leaf?`) when needed.
* Functions' first argument is the data structure, which allows chaining operations on it with the `|>` operator.

Installation
------------

.. code:: elixir
  def deps do
    [{:zippy, "~> 0.0.1"}]
  end

License
-------

MIT License

Copyright © 2017 Théophile Choutri

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


:: _Zippers: https://github.com/ferd/zippers/)

.. |elixir| image:: https://cdn.rawgit.com/tchoutri/Exon/master/elixir.svg
            :target: http://elixir-lang.org
            :alt: Made in Elixir

.. |license| image:: https://img.shields.io/badge/license-MIT-blue.svg
             :target: https://opensource.org/licenses/MIT 
             :alt: MIT License
