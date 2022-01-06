defmodule Dictionary.Impl.WordList do
  @type t :: list(String)

  @spec word_list() :: t
  def word_list do
    "assets/words.txt"
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t
  def random_word(word_list) do
    word_list
      |> Enum.random()
  end
end


# alias Dictionary.Impl.WordList
#  => Dictionary.Impl.WordList
# iex(4)> {:ok, pid} = Agent.start_link(&WordList.word_list/0)
#  => {:ok, #PID<0.13092.0>}
# Agent.get(pid, &WordList.random_word/1)
#  => "therapeutic"
