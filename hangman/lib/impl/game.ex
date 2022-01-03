defmodule Hangman.Impl.Game do
  alias Hangman.Type
  # Hangman.Impl.Game.t
  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
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

  ##################### new_game #####################
  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.pick_random_word)
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ##################### make_move #####################
  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game = %{ game_state: state }, _guess)
  when state in [:won, :lost] do
    game |>
    return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ##################### accept_guess #####################
  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end

#   defp accept_guess(game, guess, _already_used)
#   when guess in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
#  "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] do
#     %{ game | used: MapSet.put(game.used, guess) }
#     |> score_guess(Enum.member?(game.letters, guess))
#     %{ game | game_state: :invalid_value }
#   end

  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  ##################### score_guess #####################
  defp score_guess(game, _good_guess = true) do
    # A/ guessed all letters -> :won | B/ :good_guess
    # A/ tacbmwo must be a subset of wombat
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  # C/ turns_left == 1 -> :lost | D/ decrement turns_left + :bad_guess
  # C
  defp score_guess(game = %{ turns_left: 1 }, _bad_guess) do
    %{ game | game_state: :lost, turns_left: 0 }
  end

  defp score_guess(game, _bad_guess) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  defp maybe_won(true), do: :won
  defp maybe_won(false), do: :good_guess

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    { game, tally(game) }
  end

  defp reveal_guessed_letters(game) do
    game.letters
     |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter),   do: "_"
end
