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


  def assign_deltas(record) do
    record
  end


  def shift_tiers(record) do
    record
  end


  def package_output(record) do
    record
  end
end