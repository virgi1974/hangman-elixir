defmodule Dictionary.Runtime.Server do
  # alias Dictionary.Impl.WordList
  #  => Dictionary.Impl.WordList
  # iex(4)> {:ok, pid} = Agent.start_link(&WordList.word_list/0)
  #  => {:ok, #PID<0.13092.0>}
  # Agent.get(pid, &WordList.random_word/1)
  #  => "therapeutic"

  @type t :: pid()

  alias Dictionary.Impl.WordList

  def start_link do
    Agent.start_link(&WordList.word_list/0)
  end

  def random_word(pid) do
    Agent.get(pid, &WordList.random_word/1)
  end
end
