defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  test "calculate points" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3}
    ]
    points = MagiratorCalculator.calculate_pdiff(results)
    assert is_number points
    assert points == 6-1
  end

  test "calculate points with cap 3" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 10, wins: 5, losses: 10}, 
    ]
    points = MagiratorCalculator.calculate_pdiff_cap(results, 3)
    assert is_number points
    assert points == 3-1-3
  end

  test "calculate points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2},
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_pdist(results, 2)
    assert is_number points
    assert points == 3-1-3+2
  end

  test "calculate positive points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_pdist_positive(results, 2)
    assert is_number points
    assert points == 3+0+0+2
  end

  test "calculate winrate" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
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
