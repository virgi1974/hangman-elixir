# API
defmodule Hangman do
  alias Hangman.Runtime.Server
  alias Hangman.Type

  @opaque game_pid :: Server.t
  @opaque tally :: Type.tally

  @spec new_game() :: pid
  def new_game do
    { :ok, pid } = Server.start_link
    pid
  end

  @spec make_move(game_pid, String.t) :: { pid, Type.tally }
  def make_move(pid, guess) do
    GenServer.call(pid, { :make_move, guess })
  end

  @spec tally(game_pid) :: tally
  def tally(pid) do
    GenServer.call(pid, { :tally })
  end
end
