defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  use GenServer # this macro tells Elixir that this module
  # can be used as a server

  ###### client process code

  def start_link do
    # GenServer is going to create a brand new process,
    # and then inside that process, it is going to callback to
    # our init function
    GenServer.start_link(__MODULE__, nil)
  end

  ###### server process code

  def init(_) do
    # the state we need to return is the state of the server
    # when it first starts up.
    state = Game.new_game
    { :ok, state }
  end

  def handle_call({ :make_move, guess }, _from, game_state) do

    { updated_game, tally } = Game.make_move(game_state, guess)
    { :reply, tally, updated_game }
  end

  def handle_call({ :tally }, _from, game_state) do
    { :reply, Game.tally(game_state), game_state }
  end
end
