defmodule Dictionary do
  alias Dictionary.Impl.WordList

  @opaque words :: List

  @spec start() :: List
  defdelegate start(), to:  WordList

  @spec random_word(List) :: String.t
  defdelegate random_word(words), to:  WordList
end
