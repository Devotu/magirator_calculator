defmodule MagiratorCalculator.Tier do
  
  @doc """
  intiates a record in the result used by other module functions 
  %{"n": {delta, tier}}
  """
  def init_record(results) when is_list results do
    record = results
    |> Enum.reduce([], fn(x, l)-> l ++ [x.deck_id_first, x.deck_id_second] end)
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn(x, m)-> Map.put(m, x, %{delta: 0, tier: 0}) end)

    record
  end


  def validate({%{deck_id_first: d1, deck_id_second: d2} = result, record}) do
    case record[d1].tier == record[d2].tier do
      :true -> {result, record}
      _     -> {tier_mismatch(result, record), record}
    end
  end

  defp tier_mismatch(result, record) do
    IO.puts(":tier_mismatch - #{Kernel.inspect(result)} - #{Kernel.inspect(record)}")
    {:invalid, :tier_mismatch}
  end


  def assign_deltas({%{deck_id_first: d1, deck_id_second: d2} = result, record}) do
    record = 
    record
    |> Map.put(d1, Map.put(record[d1], :delta, record[d1].delta + delta_first(result)))
    |> Map.put(d2, Map.put(record[d2], :delta, record[d2].delta + delta_second(result)))
    {result, record}
  end

  def assign_deltas({{:invalid, :tier_mismatch} = result, record}) do
    {result, record}
  end

  defp delta_first(%{place_first: p}) when p == 1, do: 1
  defp delta_first(%{place_first: p}) when p > 1, do: -1
  defp delta_first(%{place_first: _p}), do: 0

  defp delta_second(%{place_second: p}) when p == 1, do: 1
  defp delta_second(%{place_second: p}) when p > 1, do: -1
  defp delta_second(%{place_second: _p}), do: 0


  def shift_tiers({%{deck_id_first: d1, deck_id_second: d2} = result, record}) do
    record = 
    record
    |> Map.put(d1, shift_tier(record[d1]))
    |> Map.put(d2, shift_tier(record[d2]))

    {result, record}
  end

  def shift_tiers({{:invalid, :tier_mismatch} = result, record}) do
    {result, record}
  end

  defp shift_tier(%{delta: d, tier: t} = dx) do
    case d do
      2 -> 
        dx
        |> Map.put(:delta, 0)
        |> Map.put(:tier, (t+1))
      -2 -> 
        dx
        |> Map.put(:delta, 0)
        |> Map.put(:tier, (t-1))
      _ -> 
        dx
    end
  end


  def record_output({_result, record}) do
    record
  end
end