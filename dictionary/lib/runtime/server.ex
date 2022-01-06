defmodule Dictionary.Runtime.Server do
  @type t :: pid()

  @me __MODULE__

  use Agent # This allows the supervisor to know that it is a supervised agent

  alias Dictionary.Impl.WordList

  def start_link(_) do
    # this method is called by the supervisor, so any process being started
    # here is gonna be linked to the supervisor
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  def random_word do
    # if :rand.uniform < 0.333 do
    #   Agent.get(@me, fn _ -> exit(:boom) end)
    # end
    Agent.get(@me, &WordList.random_word/1)
  end
end
