defmodule MagiratorCalculator do
  alias MagiratorCalculator.Points, as: P
  alias MagiratorCalculator.Tier, as: T
  alias MagiratorCalculator.Color, as: C

  #Exposed
  def calculate_summary_list_pdiff(results) when length(results) == 0 do
    0 
  end

  def calculate_summary_list_pdiff(results) do
    results
    |> Enum.map(&P.diff/1)
    |> Enum.sum()
  end


  def calculate_summary_list_pdiff_cap(results, _) when length(results) == 0 do
    0 
  end

  def calculate_summary_list_pdiff_cap(results, cap) do
    results
    |> Enum.map(fn(x) -> P.diff_cap(x, cap) end)
    |> Enum.sum()
  end


  def calculate_summary_list_pdist(results, _) when length(results) == 0 do
    0 
  end

  def calculate_summary_list_pdist(results, dist) do
    results
    |> Enum.map(fn(x) -> P.diff(x) end)
    |> Enum.map(fn(x) -> P.distributeByDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_summary_list_pdist_positive(results, _) when length(results) == 0 do
    0 
  end

  def calculate_summary_list_pdist_positive(results, dist) do
    results
    |> Enum.map(fn(x) -> P.diff(x) end)
    |> Enum.map(fn(x) -> P.distributeByPositiveDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_summary_list_winrate(results) when length(results) == 0 do
    50.0    
  end

  def calculate_summary_list_winrate(results) do
    
    combined_results = Enum.reduce(
      results, 
      %{games: 0, wins: 0}, 
      fn(r, acc) -> Map.merge(
        acc, 
        r, 
        fn(_k, current, added) -> current + added end
      ) end
    )

    Float.round((combined_results.wins / combined_results.games) * 100, 1)
  end

  def count_summary_list_games(results) do
    results
    |> Enum.map(&(&1.games))
    |> Enum.sum()
  end

  def count_summary_list_wins(results) do
    results
    |> Enum.map(&(&1.wins))
    |> Enum.sum()
  end

  def count_summary_list_losses(results) do
    results
    |> Enum.map(&(&1.losses))
    |> Enum.sum()
  end

  def count_summary_list_draws(results) do
    results
    |> Enum.map(&(&1.games - (&1.wins + &1.losses)))
    |> Enum.sum()
  end


  @doc """
  Summarizes the occasions of places 1, 0 and 2+ as {wins, draws, losses}
  Requires a summary_list containing maps with a :place value
  """
  def summarize_places(results) do
    %{
      wins: Enum.count(results, fn x -> x.place == 1 end),   
      draws: Enum.count(results, fn x -> x.place == 0 end),      
      losses: Enum.count(results, fn x -> x.place >= 2 end)      
    }
  end


  @doc """
  Summarizes the occasions of places 1, 0 and 2+ as {wins, draws, losses}
  Grouped by opposing deck
  Requires a summary_list containing maps with a :place value
  """
  def summarize_places_by_opponent_deck(results) do
    results
    |> Enum.group_by(fn(x)-> x.opponent_deck_id end)
    |> Enum.map(fn({k,v})-> Map.merge(summarize_places(v), %{opponent_deck_id: k}) end)
  end


  @doc """
  Calculates a winrate with wins vs non-wins on a summary
  """
  def calculate_summary_winrate(%{wins: 0, draws: 0, losses: 0}) do
    50.0
  end

  def calculate_summary_winrate(%{wins: wins, draws: draws, losses: losses}) do
    wins + draws + losses
    |> (fn sum -> wins/sum end).()
    |> (fn winrate -> winrate * 100 end).()
    |> Float.round(1)
  end


  @doc """
  Calculates the difference between #wins - #losses
  Draws do not affect the result
  """
  def calculate_summary_pdiff(%{wins: _wins, losses: _losses} = result) do
    P.diff(result)
  end


  @doc """
  Calculates the difference between #wins - #losses with a given hard cap
  Draws do not affect the result
  """
  def calculate_summary_pdiff_cap(%{wins: _wins, losses: _losses} = result, cap) do
    P.diff_cap(result, cap)
  end


  @doc """
  Calculates the difference between #wins - #losses with a given hard cap
  Draws do not affect the result
  """
  def calculate_summary_pdiff_cap(%{wins: _wins, losses: _losses} = result, cap) do
    P.diff_cap(result, cap)
  end


  @doc """
  Distributes points every diff x
  Draws do not affect the result
  """
  def calculate_summary_pdist(%{wins: _wins, losses: _losses} = result, dist) do
    P.diff(result)
    |> P.distributeByDistance(dist)
  end


  @doc """
  Distributes points every positive diff x 
  Draws do not affect the result
  """
  def calculate_summary_pdist_positive(%{wins: _wins, losses: _losses} = result, dist) do
    P.diff(result)
    |> P.distributeByPositiveDistance(dist)
  end


  def trace_tier(results) do
    Enum.reduce(results, T.init_record(results), fn r, acc -> resolve_tier_change(r, acc) end)
  end


  def resolve_tier_change(deck_first, result_first, deck_second, result_second) do
    record = T.init_record(deck_first, deck_second)
    result = T.construct_result(result_first.game_id, result_first.deck_id, result_first.place, result_second.deck_id, result_second.place)
    resolve_tier_change(result, record)
  end

  def resolve_tier_change(result, record) do
    {result, record}
    |> T.validate()
    |> T.assign_deltas()
    |> T.shift_tiers()
    |> T.record_output()
  end


  def count_color_occurances(decks) when is_list decks do
    C.count_color_occurances(decks)
  end


  def count_color_combinations(decks) when is_list decks do
    C.count_color_combinations(decks)
  end
end
