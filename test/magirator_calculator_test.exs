defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  test "calculate aggregated points" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3}
    ]
    points = MagiratorCalculator.calculate_aggregate_pdiff(results)
    assert is_number points
    assert points == 6-1
  end

  test "calculate aggregated points with cap 3" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 10, wins: 5, losses: 10}, 
    ]
    points = MagiratorCalculator.calculate_aggregate_pdiff_cap(results, 3)
    assert is_number points
    assert points == 3-1-3
  end

  test "calculate aggregated points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2},
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_aggregate_pdist(results, 2)
    assert is_number points
    assert points == 3-1-3+2
  end

  test "calculate aggregated positive points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_aggregate_pdist_positive(results, 2)
    assert is_number points
    assert points == 3+0+0+2
  end

  test "calculate aggregated winrate" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    winrate = MagiratorCalculator.calculate_aggregate_winrate(results)
    assert 63.6 = winrate
  end

  test "calculate aggregated winrate no games" do
    results = []
    winrate = MagiratorCalculator.calculate_aggregate_winrate(results)
    assert 50.0 = winrate
  end

 test "count aggregated games" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 11 = MagiratorCalculator.count_aggregate_games(results)
  end

 test "count aggregated wins" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 7 = MagiratorCalculator.count_aggregate_wins(results)
  end

 test "count aggregated draws" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 1 = MagiratorCalculator.count_aggregate_draws(results)
  end

 test "count aggregated losses" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 3 = MagiratorCalculator.count_aggregate_losses(results)
  end


  test "count placings" do
    results = [
      %{place: 1},
      %{place: 2},
      %{place: 1, game_id: 40},
      %{place: 2, other: %{things: "stuff"}},
      %{place: 0},
      %{place: 2},
      %{place: 3},
    ]
    
    %{wins: wins, draws: draws, losses: losses} = MagiratorCalculator.summarize_places(results)
    assert wins == 2
    assert draws == 1
    assert losses == 4
  end


  test "calculate summarized winrate" do
    summary = %{wins: 12, draws: 2, losses: 7}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 57.1 = winrate
  end

  test "calculate summarized winrate no games" do
    summary = %{wins: 0, draws: 0, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 50.0 = winrate
  end

  test "calculate summarized winrate no wins" do
    summary = %{wins: 0, draws: 0, losses: 10}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 0.0 = winrate
  end

  test "calculate summarized winrate no losses" do
    summary = %{wins: 10, draws: 0, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 100.0 = winrate
  end

  test "calculate summarized winrate only draws" do
    summary = %{wins: 0, draws: 10, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 0.0 = winrate
  end
end
