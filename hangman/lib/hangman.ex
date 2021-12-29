# API
defmodule Hangman do
  alias Hangman.Impl.Game

  @type game :: any
  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters: list(String.t),
    used: list(String.t)
  }
  @type state :: :initialising | :won | :lost | :good_guess | :bad_guess | :already_used

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec make_move(game, String.t) :: { game, tally }
  def make_move(_game, _guess) do

  end
end
