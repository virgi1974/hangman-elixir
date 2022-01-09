defmodule Dictionary.Runtime.Application do
  use Application

  def start(_type, _args) do
    IO.puts "Starting Dictionary app"
    children = [
      # Dictionary.Runtime.Server -> name of the module (with a start_link function to be called)
      # [] -> arguments to pass to the start_link funcition
      { Dictionary.Runtime.Server, [] }
    ]

    options = [
      # name -> name to be given to the supervisor
      name: Dictionary.Runtime.Supervisor,
      # strategy to handle the crashes | one_for_one -> treat each of the processes
      # (now we only have one) as independent processes.
      strategy: :one_for_one
    ]

    # the start function purpose is to return the top level process
    # in our case it will return the supervisor that we start
    Supervisor.start_link(children, options)
  end
end
