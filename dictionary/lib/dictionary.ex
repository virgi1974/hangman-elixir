defmodule Dictionary do
  alias Dictionary.Impl.WordList
  @opaque t :: WordList.t

  @opaque words :: List

  @spec start() :: t
  defdelegate start(), to:  WordList, as: :word_list

  @spec random_word(t) :: String.t
  defdelegate random_word(words), to:  WordList
end
