defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new_game returns structure" do
    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.turns_left == 7
  end

  test "new_game returns correct word" do
    game = Game.new_game("wombat")

    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "letters are all downcase" do
    game = Game.new_game

    game.letters |> Enum.map(fn letter ->
      assert (:binary.first(letter) in 97..122) == true
    end)
  end

  test "state doesn't change if a game is won" do
    game = Game.new_game("wombat")
    game = Map.put(game, :game_state, :won)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
  end
end
