defmodule MagiratorCalculator do

  def calculate_pdiff(results) when length(results) == 0 do
    0 
  end

  def calculate_pdiff(results) do
    wins(results) - losses(results)    
  end


  def calculate_pdiff_cap(results, _) when length(results) == 0 do
    0 
  end

  def calculate_pdiff_cap(results, cap) do
    results
    |> Enum.group_by( &(&1.deck_id) )
    |> Enum.map( fn({deck_id, results}) -> results end )
    |> Enum.map( &calculate_pdiff/1 )
    |> Enum.map( fn(p) -> cap_points(p, cap) end )
    |> Enum.sum()
  end


  defp wins(results) do
    results
      |> Enum.filter( &(&1.place == 1) )
      |> Enum.count()
  end

  defp losses(results) do
    results
      |> Enum.filter( &(&1.place != 1) )
      |> Enum.count()
  end

  defp cap_points(points, cap) do
    case points > cap do
      :true ->
        cap
      _ ->
        points
    end
  end




  # Currently under development
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
end
