defmodule MagiratorCalculator.Points do
  
  def diff(result) do
    result.wins - result.losses
  end

  def diff_cap(result, cap) do
    result
    |> diff()
    |> enforcePositiveCap(cap)
    |> enforceNegativeCap(cap)
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


  def distributeByDistance(value, dist) do
    case value > 0 do
      :true -> distributeByPositiveDistance(value, dist)
      _ -> distributeByNegativeDistance(value, dist)        
    end
  end

  def distributeByPositiveDistance(value, dist) do
    value
    |> enforceNegativeCap(0)
    |> Kernel.+(1)
    |> Kernel./(dist)
    |> trunc()
  end

  def distributeByNegativeDistance(value, dist) do
    value
    |> Kernel.-(1)
    |> Kernel./(dist)
    |> trunc()
  end
end