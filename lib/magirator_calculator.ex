defmodule MagiratorCalculator do

  def calculate_points(results) do
    
    points =
      results
      |> Enum.filter( &(&1.place == 1) )
      |> Enum.map( &(&1).place )
      |> Enum.sum()
      
  end
end
