defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  test "calculate points" do
    results = [
      %{id: 20, games: 10, losses: 2, wins: 8}, 
      %{id: 21, games: 5, losses: 3, wins: 2}
    ]
    points = MagiratorCalculator.calculate_pdiff(results)
    assert is_number points
    assert points == 6-1
  end

  test "calculate points with cap 3" do
    results = [
      %{id: 20, games: 10, losses: 2, wins: 8}, 
      %{id: 21, games: 5, losses: 3, wins: 2},
      %{id: 22, games: 10, losses: 10, wins: 5}, 
    ]
    points = MagiratorCalculator.calculate_pdiff_cap(results, 3)
    assert is_number points
    assert points == 3-1-3
  end

  test "calculate points with dist 2" do
    results = [
      %{id: 20, games: 10, losses: 2, wins: 8}, 
      %{id: 21, games: 5, losses: 3, wins: 2},
      %{id: 22, games: 10, losses: 10, wins: 5}, 
      %{id: 22, games: 10, losses: 2, wins: 5}, 
    ]
    points = MagiratorCalculator.calculate_pdist(results, 2)
    assert is_number points
    assert points == 3+0+0+2
  end

  test "calculate winrate" do
    results = [
      %{id: 20, games: 5, losses: 1, wins: 4}, 
      %{id: 21, games: 6, losses: 2, wins: 3}
    ]
    winrate = MagiratorCalculator.calculate_winrate(results)
    assert 63.6 = winrate
  end

  test "calculate winrate no games" do
    results = []
    winrate = MagiratorCalculator.calculate_winrate(results)
    assert 50.0 = winrate
  end
end
