defmodule Dictionary.Impl.WordList do
  def start do
    "assets/words.txt"
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
  end

  def random_word(words) do
    words
      |> Enum.random()
  end
end
