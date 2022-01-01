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

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "b")
    assert MapSet.equal?(game.used, MapSet.new(["b"]))
    # stored only once
    {game, _tally} = Game.make_move(game, "b")
    assert MapSet.equal?(game.used, MapSet.new(["b"]))
    # stored in sorted way
    {game, _tally} = Game.make_move(game, "a")
    assert MapSet.equal?(game.used, MapSet.new(["a", "b"]))
  end
end
