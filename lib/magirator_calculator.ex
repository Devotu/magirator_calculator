defmodule MagiratorCalculator do

  def calculate_pdiff(results) when length(results) == 0 do
    0 
  end

  def calculate_pdiff(results) do
    wins(results) - losses(results)    
  end


  def calculate_winrate(results) when length(results) == 0 do
    0.0    
  end

  def calculate_winrate(results) do
    wins(results)/Enum.count(results)    
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
end
