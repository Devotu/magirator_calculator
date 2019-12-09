defmodule MagiratorCalculator.Tier do
  
  @doc """
  intiates a record in the result used by other module functions 
  %{"n": {delta, tier}}
  """
  def init_record(results) when is_list results do
    record = results
    |> Enum.reduce([], fn(x, l)-> l ++ [x.deck_id_one, x.deck_id_two] end)
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn(x, m)-> Map.put(m, x, %{delta: 0, tier: 0}) end)

    {:ok, record}
  end


  def validate({%{deck_id_one: d1, deck_id_two: d2} = result, record}) do
    case record[d1].tier == record[d2].tier do
      :true -> {result, record}
      _     -> {:invalid, :tier_mismatch}        
    end
  end


  def assign_deltas({%{deck_id_one: d1, deck_id_two: d2} = result, record}) do
    record = 
    record
    |> Map.put(d1, Map.put(record[d1], :delta, record[d1].delta + delta_one(result)))
    |> Map.put(d2, Map.put(record[d2], :delta, record[d2].delta + delta_two(result)))
    {result, record}
  end

  defp delta_one(%{place_one: place}) when place == 1, do: 1
  defp delta_one(%{place_one: place}) when place > 1, do: -1
  defp delta_one(%{place_one: _place}), do: 0

  defp delta_two(%{place_two: place}) when place == 1, do: 1
  defp delta_two(%{place_two: place}) when place > 1, do: -1
  defp delta_two(%{place_two: _place}), do: 0
  end


  def package_output(record) do
    record
  end
end