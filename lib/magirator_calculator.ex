defmodule MagiratorCalculator do

  #Exposed
  def calculate_aggregate_pdiff(results) when length(results) == 0 do
    0 
  end

  def calculate_aggregate_pdiff(results) do
    results
    |> Enum.map(&diff/1)
    |> Enum.sum()
  end


  def calculate_aggregate_pdiff_cap(results, _) when length(results) == 0 do
    0 
  end

  def calculate_aggregate_pdiff_cap(results, cap) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> enforcePositiveCap(x, cap) end)
    |> Enum.map(fn(x) -> enforceNegativeCap(x, cap) end)
    |> Enum.sum()
  end


  def calculate_aggregate_pdist(results, _) when length(results) == 0 do
    0 
  end

  def calculate_aggregate_pdist(results, dist) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> distributeByDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_aggregate_pdist_positive(results, _) when length(results) == 0 do
    0 
  end

  def calculate_aggregate_pdist_positive(results, dist) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> enforceNegativeCap(x, 0) end)
    |> Enum.map(fn(x) -> distributeByDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_aggregate_winrate(results) when length(results) == 0 do
    50.0    
  end

  def calculate_aggregate_winrate(results) do
    
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

  def count_aggregate_games(results) do
    results
    |> Enum.map(&(&1.games))
    |> Enum.sum()
  end

  def count_aggregate_wins(results) do
    results
    |> Enum.map(&(&1.wins))
    |> Enum.sum()
  end

  def count_aggregate_losses(results) do
    results
    |> Enum.map(&(&1.losses))
    |> Enum.sum()
  end

  def count_aggregate_draws(results) do
    results
    |> Enum.map(&(&1.games - (&1.wins + &1.losses)))
    |> Enum.sum()
  end


  #Privates
  defp diff(result) do
    result.wins - result.losses
  end


  defp enforcePositiveCap(value, cap) do
    case value > cap do
      :true -> cap
      _ -> value        
    end
  end

  defp enforceNegativeCap(value, cap) do
    case value < -cap do
      :true -> -cap
      _ -> value        
    end
  end


  defp distributeByDistance(value, dist) do
    case value > 0 do
      :true -> distributeByPositiveDistance(value, dist)
      _ -> distributeByNegativeDistance(value, dist)        
    end
  end

  defp distributeByPositiveDistance(value, dist) do
    value
    |> Kernel.+(1)
    |> Kernel./(dist)
    |> trunc()
  end

  defp distributeByNegativeDistance(value, dist) do
    value
    |> Kernel.-(1)
    |> Kernel./(dist)
    |> trunc()
  end

  @doc """
  Summarizes the occasions of places 1, 0 and 2+ as {wins, draws, losses}
  Requires a list containing maps with a :place value
  """
  def summarize_places(results) do
    %{
      wins: Enum.count(results, fn x -> x.place == 1 end),   
      draws: Enum.count(results, fn x -> x.place == 0 end),      
      losses: Enum.count(results, fn x -> x.place >= 2 end)      
    }
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
  def calculate_summary_pdiff(%{wins: wins, losses: losses}) do
    wins - losses
  end
end
