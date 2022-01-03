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

  describe "we recognize a letter in the word" do
    test "it was just a good guess" do
      game = Game.new_game("wombat")
      { _game, tally } = Game.make_move(game, "m")
      assert tally.game_state == :good_guess
    end

    test "it was a winning guess " do
      game = Game.new_game("wombat")
      game = Map.put(game, :used, MapSet.new(["w", "o", "b", "a", "t"]))
      { _game, tally } = Game.make_move(game, "m")
      assert tally.game_state == :won
    end
  end

  describe "we recognize a letter not in the word" do
    test "it was just a bad guess" do
      game = Game.new_game("wombat")
      { _game, tally } = Game.make_move(game, "v")
      assert tally.game_state == :bad_guess
    end

    test "it was a final losing guess " do
      game = Game.new_game("hello")
      { game, _tally } = Game.make_move(game, "a")
      { game, _tally } = Game.make_move(game, "b")
      { game, _tally } = Game.make_move(game, "c")
      { game, _tally } = Game.make_move(game, "d")
      { game, _tally } = Game.make_move(game, "f")
      { game, _tally } = Game.make_move(game, "n")
      { _game, tally } = Game.make_move(game, "m")
      assert tally.game_state == :lost
    end
  end

  test "can handle a sequence of moves" do
    [
      #guess    state     turns        letters            used
      ["a", :bad_guess,    6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess,   6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess,    5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
      |> test_sequence_of_moves
  end

  test "can handle a winning game" do
    [
      # guess | state     turns  letters                     used
      ["a", :bad_guess,    6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess,   6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess,    5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
      ["l", :good_guess,   5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["o", :good_guess,   5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
      ["y", :bad_guess,    4, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x", "y"]],
      ["h", :won,          4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "x", "y"]],
    ]
      |> test_sequence_of_moves
  end

  test "can handle a losing game" do
    [
      # guess | state     turns  letters                     used
      ["a", :bad_guess,    6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess,    5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess,    4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess,    3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :good_guess,   3, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess,    2, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :bad_guess,    1, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["h", :good_guess,   1, ["h", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g", "h"]],
      ["i", :lost,         0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "g", "h", "i"]],
    ]
    |> test_sequence_of_moves()
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    { game, tally } = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters    == letters
    assert tally.used       == used

    # we need to return the updated game to the next iteration of reduce
    game
  end
end
