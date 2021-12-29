defmodule Hangman.Impl.Game do
  # this structure will have the same name as the module Hangman.Impl.Game
  defstruct(
    turns_left: 7,
    game_state: :initialising,
    letters: [],
    used: MapSet.new() #this is a set cause the words should not be used again
  )
  def new_game do
    %Hangman.Impl.Game{
      letters: Dictionary.pick_random_word |> String.codepoints()
    }
  end
end
