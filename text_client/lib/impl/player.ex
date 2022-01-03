defmodule TextClient.Impl.Player do
  @typep game  :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  ###################### start ###################
  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  ###################### interact ###################
  def interact({_game, _tally = %{ game_state: :won }}) do
    IO.puts("Congrats you won!!!!")
  end

  def interact({_game, tally = %{ game_state: :lost }}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join()}")
  end

  @spec interact(state) :: :ok
  def interact({ game, tally }) do
    # it's gonna do many things

    # 1 - give some feedback
    IO.puts feedback_for(tally)

    # 2 - display the current word
    IO.puts(current_word(tally))

    # 3 - get the next guess
    guess = get_guess

    # 4 - make a move
    { updated_game, updated_tally } = Hangman.make_move(game, guess)

    # 5 - call itself again interact()
    interact({ updated_game, updated_tally })
  end

  ###################### feedback_for ###################
  # @type state :: :initializing | :good_guess | :bad_guess | :already_used | :invalid_value
  def feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(%{ game_state: :good_guess }), do: "Good guess!"
  def feedback_for(%{ game_state: :bad_guess }), do: "Sorry, that letter is not in the word"
  def feedback_for(%{ game_state: :already_used }), do: "You already used that letter"

  ###################### current_word ###################
  def current_word(tally) do
    [
      "Word so far: ", tally.letters |> Enum.join(" "),
      "    turns left: ", tally.turns_left |> to_string,
      "    used so far: ", tally.used |> Enum.join(",")
    ]
  end

  ###################### get_guess ###################
  def get_guess do
    IO.gets("Next letter: ")
    |> String.trim() # to remove the new line character
    |> String.downcase()
  end
end
