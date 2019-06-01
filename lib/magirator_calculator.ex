defmodule MagiratorCalculator do

  #Exposed
  def calculate_pdiff(results) when length(results) == 0 do
    0 
  end

  def calculate_pdiff(results) do
    results
    |> Enum.map(&diff/1)
    |> Enum.sum()
  end


  def calculate_pdiff_cap(results, _) when length(results) == 0 do
    0 
  end

  def calculate_pdiff_cap(results, cap) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> enforcePositiveCap(x, cap) end)
    |> Enum.map(fn(x) -> enforceNegativeCap(x, cap) end)
    |> Enum.sum()
  end


  def calculate_pdist(results, _) when length(results) == 0 do
    0 
  end

  def calculate_pdist(results, dist) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> distributeByDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_pdist_positive(results, _) when length(results) == 0 do
    0 
  end

  def calculate_pdist_positive(results, dist) do
    results
    |> Enum.map(&diff/1)
    |> Enum.map(fn(x) -> enforceNegativeCap(x, 0) end)
    |> Enum.map(fn(x) -> distributeByDistance(x, dist) end)
    |> Enum.sum()
  end


  def calculate_winrate(results) when length(results) == 0 do
    50.0    
  end

  def calculate_winrate(results) do
    
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

  def count_games(results) do
    results
    |> Enum.map(&(&1.games))
    |> Enum.sum()
  end

  def count_wins(results) do
    results
    |> Enum.map(&(&1.wins))
    |> Enum.sum()
  end

  def count_losses(results) do
    results
    |> Enum.map(&(&1.losses))
    |> Enum.sum()
  end

  def count_draws(results) do
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
end
