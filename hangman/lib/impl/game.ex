defmodule Hangman.Impl.Game do
  # Hangman.Impl.Game.t
  @type t :: %Hangman.Impl.Game{
    turns_left: integer,
    game_state: Hangman.state,
    letters: list(String.t),
    used: MapSet.t(String.t) #t
  }

  # this structure will have the same name as the module Hangman.Impl.Game
  # it will be the data structure the module returns -> %Hangman.Impl.Game{}
  defstruct(
    turns_left: 7,
    game_state: :initialising,
    letters: [],
    used: MapSet.new() #this is a set cause the words should not be used again
  )
  def new_game do
    # syntax to create a structure
    %__MODULE__{
      # overwriting specific keys
      letters: Dictionary.pick_random_word |> String.codepoints()
    }
  end

end
