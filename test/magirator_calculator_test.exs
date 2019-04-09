defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  test "calculate points" do
    results = 
      [
        %{comment: "Third result", created: 1552337401729, id: 32, place: 1}, 
        %{comment: "First result", created: 1552337401701, id: 30, place: 1},
      ]

    points = MagiratorCalculator.calculate_pdiff(results)
    assert is_number points
  end

  test "calculate winrate" do
    results = [%{id: 20, games: 5, losses: 1, wins: 4}, %{id: 21, games: 6, losses: 2, wins: 3}]
    winrate = MagiratorCalculator.calculate_winrate(results)
    assert 63.6 = winrate
  end

  test "calculate winrate no games" do
    results = []
    winrate = MagiratorCalculator.calculate_winrate(results)
    assert 50.0 = winrate
  end
end
