defmodule MagiratorCalculator.Tier do
  
  @doc """
  intiates a record in the result used by other module functions 
  %{"n": {delta, tier}}
  """
  def init_record(results) when is_list results do
    results
    |> Enum.reduce([], fn(x, l)-> l ++ [x.deck_id_first, x.deck_id_second] end)
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn(x, m)-> Map.put(m, x, %{delta: 0, tier: 0}) end)
  end

  def init_record(%{id: id_first, tier: tier_first, delta: delta_first}, %{id: id_second, tier: tier_second, delta: delta_second}) do
    %{
      id_first => %{delta: delta_first, tier: tier_first}, 
      id_second => %{delta: delta_second, tier: tier_second}
    }
  end

  @doc """
  Constructs a result in the format that the module utilizes
  %{game_id: x, deck_id_first: y, place_first: z, deck_id_second: y, place_second: z}
  """
  def construct_result(game_id, deck_id_first, place_first, deck_id_second, place_second) do
    %{game_id: game_id, deck_id_first: deck_id_first, place_first: place_first, deck_id_second: deck_id_second, place_second: place_second}
  end


  def validate({%{deck_id_first: deck_id_first, deck_id_second: deck_id_second} = result, record}) do
    case record[deck_id_first].tier == record[deck_id_second].tier do
      :true -> {result, record}
      _     -> {tier_mismatch(result, record), record}
    end
  end

  defp tier_mismatch(result, record) do
    IO.puts(":tier_mismatch - #{Kernel.inspect(result)} - #{Kernel.inspect(record)}")
    {:invalid, :tier_mismatch}
  end


  def assign_deltas({%{deck_id_first: deck_id_first, place_first: place_first, deck_id_second: deck_id_second, place_second: place_second} = result, record}) do
    record = 
    record
    |> Map.put(deck_id_first, Map.put(record[deck_id_first], :delta, adjust_delta(record[deck_id_first].delta, place_first) |> cap_delta(record[deck_id_first].tier)))
    |> Map.put(deck_id_second, Map.put(record[deck_id_second], :delta, adjust_delta(record[deck_id_second].delta, place_second) |> cap_delta(record[deck_id_second].tier)))
    {result, record}
  end

  def assign_deltas({{:invalid, :tier_mismatch} = result, record}) do
    {result, record}
  end

  def adjust_delta(delta, place) when place == 1, do: delta + 1
  def adjust_delta(delta, place) when place > 1, do: delta - 1
  def adjust_delta(delta, _place), do: delta

  defp cap_delta(2, 2), do: 1
  defp cap_delta(-2, -2), do: -1
  defp cap_delta(d, _t), do: d


  def shift_tiers({%{deck_id_first: deck_id_first, deck_id_second: deck_id_second} = result, record}) do
    record = 
    record
    |> Map.put(deck_id_first, shift_tier(record[deck_id_first]))
    |> Map.put(deck_id_second, shift_tier(record[deck_id_second]))
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