defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  @tag points: true
  test "calculate list of summaries points" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3}
    ]
    points = MagiratorCalculator.calculate_summary_list_pdiff(results)
    assert is_number points
    assert points == 6-1
  end

  @tag points: true
  test "calculate list of summaries points with cap 3" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 10, wins: 5, losses: 10}, 
    ]
    points = MagiratorCalculator.calculate_summary_list_pdiff_cap(results, 3)
    assert is_number points
    assert points == 3-1-3
  end

  @tag points: true
  test "calculate list of summaries points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2},
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_summary_list_pdist(results, 2)
    assert is_number points
    assert points == 3-1-3+2
  end


  @tag points: true
  test "calculate list of summaries positive points with dist 2" do
    results = [
      %{id: 20, games: 10, wins: 8, losses: 2}, 
      %{id: 21, games: 5, wins: 2, losses: 3},
      %{id: 22, games: 15, wins: 5, losses: 10}, 
      %{id: 23, games: 8, wins: 5, losses: 2}, 
    ]
    points = MagiratorCalculator.calculate_summary_list_pdist_positive(results, 2)
    assert is_number points
    assert points == 3+0+0+2
  end


  @tag winrate: true
  test "calculate list of summaries winrate" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    winrate = MagiratorCalculator.calculate_summary_list_winrate(results)
    assert 63.6 = winrate
  end

  @tag winrate: true
  test "calculate list of summaries winrate no games" do
    results = []
    winrate = MagiratorCalculator.calculate_summary_list_winrate(results)
    assert 50.0 = winrate
  end

 test "count list of summaries games" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 11 = MagiratorCalculator.count_summary_list_games(results)
  end

 test "count list of summaries wins" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 7 = MagiratorCalculator.count_summary_list_wins(results)
  end

 test "count list of summaries draws" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 1 = MagiratorCalculator.count_summary_list_draws(results)
  end

 test "count list of summaries losses" do
    results = [
      %{id: 20, games: 5, wins: 4, losses: 1}, 
      %{id: 21, games: 6, wins: 3, losses: 2}
    ]
    assert 3 = MagiratorCalculator.count_summary_list_losses(results)
  end


  @tag count: true
  test "count placings" do
    results = [
      %{place: 1, opponent_deck_id: 1},
      %{place: 2, opponent_deck_id: 1},
      %{place: 3, opponent_deck_id: 2},
      %{place: 1, opponent_deck_id: 2},
      %{place: 1, opponent_deck_id: 2},
      %{place: 2, opponent_deck_id: 2},
      %{place: 0, opponent_deck_id: 3},
    ]
    
    %{wins: wins, draws: draws, losses: losses} = MagiratorCalculator.summarize_places(results)
    assert wins == 3
    assert draws == 1
    assert losses == 3
  end


  @tag count: true
  test "count placings order by opponent deck" do
    results = [
      %{place: 1, opponent_deck_id: 1},
      %{place: 2, opponent_deck_id: 1},
      %{place: 3, opponent_deck_id: 2},
      %{place: 1, opponent_deck_id: 2},
      %{place: 1, opponent_deck_id: 2},
      %{place: 2, opponent_deck_id: 2},
      %{place: 0, opponent_deck_id: 3},
    ]
    
    result_list = MagiratorCalculator.summarize_places_by_opponent_deck(results)
    assert is_list result_list
    
    r1 = Enum.find(result_list, fn(x)-> x.opponent_deck_id == 1 end)
    assert r1.wins == 1
    assert r1.draws == 0
    assert r1.losses == 1

    r2 = Enum.find(result_list, fn(x)-> x.opponent_deck_id == 2 end)
    assert r2.wins == 2
    assert r2.draws == 0
    assert r2.losses == 2

    r3 = Enum.find(result_list, fn(x)-> x.opponent_deck_id == 3 end)
    assert r3.wins == 0
    assert r3.draws == 1
    assert r3.losses == 0
  end


  @tag winrate: true
  test "calculate summarized winrate" do
    summary = %{wins: 12, draws: 2, losses: 7}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 57.1 = winrate
  end

  @tag winrate: true
  test "calculate summarized winrate no games" do
    summary = %{wins: 0, draws: 0, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 50.0 = winrate
  end

  @tag winrate: true
  test "calculate summarized winrate no wins" do
    summary = %{wins: 0, draws: 0, losses: 10}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 0.0 = winrate
  end

  @tag winrate: true
  test "calculate summarized winrate no losses" do
    summary = %{wins: 10, draws: 0, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 100.0 = winrate
  end

  @tag winrate: true
  test "calculate summarized winrate only draws" do
    summary = %{wins: 0, draws: 10, losses: 0}
    winrate = MagiratorCalculator.calculate_summary_winrate(summary)
    assert 0.0 = winrate
  end


  @tag points: true
  test "calculate summarized points diff +" do
    summary = %{wins: 12, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff(summary)
    assert is_number points
    assert 5 == points
  end

  @tag points: true
  test "calculate summarized points diff -" do
    summary = %{wins: 2, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff(summary)
    assert is_number points
    assert -5 == points
  end

  @tag points: true
  test "calculate summarized points diff 0" do
    summary = %{wins: 7, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff(summary)
    assert is_number points
    assert 0 == points
  end


  @tag points: true
  test "calculate summarized points diff with cap 3 +" do
    summary = %{wins: 9, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff_cap(summary, 3)
    assert 2 == points
  end

  @tag points: true
  test "calculate summarized points diff with cap 3 capped +" do
    summary = %{wins: 12, draws: 2, losses: 7}
    cap = 3
    points = MagiratorCalculator.calculate_summary_pdiff_cap(summary, cap)
    assert cap == points
  end

  @tag points: true
  test "calculate summarized points diff with cap 3 -" do
    summary = %{wins: 6, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff_cap(summary, 3)
    assert -1 == points
  end

  @tag points: true
  test "calculate summarized points diff with cap 3 capped -" do
    summary = %{wins: 1, draws: 2, losses: 7}
    cap = 3
    points = MagiratorCalculator.calculate_summary_pdiff_cap(summary, cap)
    assert -cap == points
  end

  @tag points: true
  test "calculate summarized points diff with cap 3 0" do
    summary = %{wins: 7, draws: 2, losses: 7}
    points = MagiratorCalculator.calculate_summary_pdiff_cap(summary, 3)
    assert 0 == points
  end


  @tag points: true
  test "calculate summarized points dist 2" do
    summary = %{wins: 12, draws: 2, losses: 7}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist(summary, dist)
    assert 3 == points
  end

  @tag points: true
  test "calculate summarized points dist 3" do
    summary = %{wins: 12, draws: 2, losses: 7}
    dist = 3
    points = MagiratorCalculator.calculate_summary_pdist(summary, dist)
    assert 2 == points
  end

  @tag points: true
  test "calculate summarized points dist 2 -" do
    summary = %{wins: 7, draws: 1, losses: 12}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist(summary, dist)
    assert -3 == points
  end

  @tag points: true
  test "calculate summarized points dist 2 0" do
    summary = %{wins: 0, draws: 1, losses: 0}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist(summary, dist)
    assert 0 == points
  end


  @tag points: true
  test "calculate summarized points dist only positive" do
    summary = %{wins: 12, draws: 2, losses: 7}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist_positive(summary, dist)
    assert 3 == points
  end

  @tag points: true
  test "calculate summarized points dist only positive -" do
    summary = %{wins: 2, draws: 2, losses: 7}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist_positive(summary, dist)
    assert 0 == points
  end

  @tag points: true
  test "calculate summarized points dist only positive 0" do
    summary = %{wins: 0, draws: 2, losses: 0}
    dist = 2
    points = MagiratorCalculator.calculate_summary_pdist_positive(summary, dist)
    assert 0 == points
  end


  # @tag tier: true
  # test "trace tier" do
  #   results = [
  #     %{deck_id: 1, place: 1, opponent_deck_id: 2},
  #     %{deck_id: 2, place: 2, opponent_deck_id: 1},
  #     %{deck_id: 1, place: 1, opponent_deck_id: 2},
  #     %{deck_id: 2, place: 2, opponent_deck_id: 1},

  #     %{deck_id: 1, place: 1, opponent_deck_id: 3},
  #     %{deck_id: 3, place: 2, opponent_deck_id: 1},
  #     %{deck_id: 1, place: 0, opponent_deck_id: 3},
  #     %{deck_id: 3, place: 2, opponent_deck_id: 1},

  #     %{deck_id: 1, place: 2, opponent_deck_id: 2},
  #     %{deck_id: 2, place: 1, opponent_deck_id: 1},
  #     %{deck_id: 1, place: 1, opponent_deck_id: 2},
  #     %{deck_id: 2, place: 2, opponent_deck_id: 1},
  #     %{deck_id: 1, place: 2, opponent_deck_id: 2},
  #     %{deck_id: 2, place: 1, opponent_deck_id: 1},
  #   ]
    
  #   assert %{"1": 1, "2": 0, "3": -1} = MagiratorCalculator.trace_tier(results)
  # end

  @tag tier: true
  test "trace tier" do
    results = [                                                                #  0  0:  0  0:  0  0:  0  0:  0  0
      %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2}, # +1  0: -1  0:  0  0:  0  0:  0  0
      %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2}, # +2 >1: -2>-1:  0  0:  0  0:  0  0

      %{deck_id_first: 3, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1:  0 -1: +1  0: -1  0:  0  0
      %{deck_id_first: 3, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1:  0 -1: +2 >1: -2>-1:  0  0

      %{deck_id_first: 2, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1: +1 -1:  0  1: -1 -1:  0  0
      %{deck_id_first: 2, place_first: 2, deck_id_second: 4, place_second: 1}, #  0  1:  0 -1:  0  1:  0 -1:  0  0
      %{deck_id_first: 2, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1: +1 -1:  0  1: -1 -1:  0  0
      %{deck_id_first: 2, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1: +2 >0:  0  1: -2>-2:  0  0

      %{deck_id_first: 1, place_first: 1, deck_id_second: 3, place_second: 2}, # +1  1:  0  0: -1  1:  0 -2:  0  0
      %{deck_id_first: 1, place_first: 2, deck_id_second: 3, place_second: 1}, #  0  1:  0  0:  0  1:  0 -2:  0  0
      %{deck_id_first: 1, place_first: 1, deck_id_second: 3, place_second: 2}, # +1  1:  0  0: -1  1:  0 -2:  0  0
      %{deck_id_first: 1, place_first: 1, deck_id_second: 3, place_second: 2}, # +2 >2:  0  0: -2 >0:  0 -2:  0  0

      %{deck_id_first: 2, place_first: 1, deck_id_second: 3, place_second: 2}, #  0  2: +1  0: -1  0:  0 -2:  0  0

      %{deck_id_first: 3, place_first: 1, deck_id_second: 5, place_second: 2}, #  0  2: +1  0:  0  0:  0 -2: -1  0

      %{deck_id_first: 2, place_first: 1, deck_id_second: 5, place_second: 2}, #  0  2: +2 >1:  0  0:  0 -2: -2>-1

      %{deck_id_first: 2, place_first: 1, deck_id_second: 5, place_second: 2}, #  0  2:  0  1:  0  0:  0 -2:  0 -1
      %{deck_id_first: 2, place_first: 1, deck_id_second: 5, place_second: 2}, #  0  2:  0  1:  0  0:  0 -2:  0 -1
      %{deck_id_first: 2, place_first: 1, deck_id_second: 5, place_second: 2}, #  0  2:  0  1:  0  0:  0 -2:  0 -1

    ]
    
    # assert %{1=> %{delta: 0, tier: 1}, 2=> %{delta: 0, tier: -1}, 3=> %{delta: 0, tier: 1}, 4=> %{delta: 0, tier: -1}} = MagiratorCalculator.trace_tier(results) #4
    # assert %{1=> %{delta: 0, tier: 1}, 2=> %{delta: 0, tier: 0}, 3=> %{delta: 0, tier: 1}, 4=> %{delta: 0, tier: -2}} = MagiratorCalculator.trace_tier(results) #8
    # assert %{1=> %{delta: 0, tier: 2}, 2=> %{delta: 0, tier: 0}, 3=> %{delta: 0, tier: 0}, 4=> %{delta: 0, tier: -2}} = MagiratorCalculator.trace_tier(results) #12
    # assert %{1=> %{delta: 0, tier: 2}, 2=> %{delta: 0, tier: 1}, 3=> %{delta: 0, tier: 0}, 4=> %{delta: 0, tier: -2}, 5=> %{delta: 0, tier: -1}} = MagiratorCalculator.trace_tier(results) #15
    assert %{1=> %{delta: 0, tier: 2}, 2=> %{delta: 0, tier: 1}, 3=> %{delta: 0, tier: 0}, 4=> %{delta: 0, tier: -2}, 5=> %{delta: 0, tier: -1}} = MagiratorCalculator.trace_tier(results) #18
  end


  @tag tier: true
  test "resolve tier change delta" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:  0  0
    record = %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}}
    
    assert %{1=> %{delta: 1, tier: 0}, 2=> %{delta: -1, tier: 0}} = MagiratorCalculator.resolve_tier_change(result, record)
  end

  @tag tier: true
  test "resolve tier change tier" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:  0  0
    record = %{1 => %{delta: 1, tier: 0}, 2 => %{delta: 1, tier: 0}}
    
    assert %{1=> %{delta: 0, tier: 1}, 2=> %{delta: 0, tier: 0}} = MagiratorCalculator.resolve_tier_change(result, record)
  end
end
