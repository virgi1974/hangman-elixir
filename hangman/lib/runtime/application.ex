defmodule Hangman.Runtime.Application do
  @super_name GameStarter

  use Application

  # this will start a dynamic supervisor
  def start(_type, _args) do
    IO.puts("Starting GameStarter app")
    # we define the dynamic supervisor spec
    supervisor_spec = [
      { DynamicSupervisor,
      strategy: :one_for_one,
      name: @super_name }
    ]

    # strategy -> is the strategy the supervisor is using on the
    # dynamic supervisor
    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  # this will start the game server
  def start_game do
    IO.puts("creating game")
    DynamicSupervisor.start_child(@super_name, { Hangman.Runtime.Server, nil })
  end
end
