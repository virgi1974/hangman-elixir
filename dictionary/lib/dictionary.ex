defmodule Dictionary do
  @word_list "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  def pick_random_word do
    @word_list
      |> Enum.random()
  end
end
