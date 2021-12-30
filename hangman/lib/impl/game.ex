defmodule Hangman.Impl.Game do
  # Hangman.Impl.Game.t
  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Hangman.state,
    letters: list(String.t),
    used: MapSet.t(String.t) #t
  }

  # this structure will have the same name as the module Hangman.Impl.Game
  # it will be the data structure the module returns -> %Hangman.Impl.Game{}
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new() #this is a set cause the words should not be used again
  )
  def new_game do
    new_game(Dictionary.pick_random_word)
  end

    def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

end
