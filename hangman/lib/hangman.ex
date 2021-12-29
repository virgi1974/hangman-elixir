defmodule Hangman do

  @type game :: any
  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters: list(String.t),
    used: list(String.t)
  }
  @type state :: :initialising | :won | :lost | :good_guess | :bad_guess | :already_used

  @spec new_game() :: game
  def new_game do
  end

  @spec make_move(game, String.t) :: { game, tally }
  def make_move(_game, _guess) do

  end
end
