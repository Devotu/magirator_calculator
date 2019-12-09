defmodule TierTest do
  use ExUnit.Case

  alias MagiratorCalculator.Tier, as: Tier

  @tag init: true
  test "initialize record" do
    results = [                                                      #  0  0:  0  0:  0  0:  0  0:
      %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2}, # +1  0: -1  0:  0  0:  0  0:
      %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2}, # +2 >1: -2>-1:  0  0:  0  0:
      %{deck_id_one: 3, place_one: 1, deck_id_two: 4, place_two: 2}, #  0  1:  0 -1: +1  0: -1  0:
      %{deck_id_one: 3, place_one: 1, deck_id_two: 4, place_two: 2}, #  0  1:  0 -1: +2 >1: -2>-1:
    ]

    assert {:ok, %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}, 3 => %{delta: 0, tier: 0}, 4 => %{delta: 0, tier: 0}}} == Tier.init_record(results)
  end


  @tag validate: true
  test "validate record true" do
    result = %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}}

    assert {result, record} == Tier.validate({result, record})
  end

  @tag validate: true
  test "validate record false" do
    result = %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 1}, 2 => %{delta: 0, tier: 0}}

    assert {:invalid, :tier_mismatch} == Tier.validate({result, record})
  end


  @tag assign: true
  test "assign 0/0 -> 1/-1" do
    result = %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}}

    assert {result, %{1 => %{delta: 1, tier: 0}, 2 => %{delta: -1, tier: 0}}} == Tier.assign_deltas({result, record})
  end

  @tag assign: true
  test "assign -1/1 -> -2/2" do
    result = %{deck_id_one: 1, place_one: 2, deck_id_two: 2, place_two: 1} # -1  0: +1  0:  0  0:  0  0:
    record = %{1 => %{delta: -1, tier: -1}, 2 => %{delta: 1, tier: -1}}

    assert {result, %{1 => %{delta: -2, tier: -1}, 2 => %{delta: 2, tier: -1}}} == Tier.assign_deltas({result, record})
  end

  @tag assign: true
  test "assign -1/-1 -> 0/-2" do
    result = %{deck_id_one: 1, place_one: 1, deck_id_two: 2, place_two: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: -1, tier: 1}, 2 => %{delta: -1, tier: 1}}

    assert {result, %{1 => %{delta: 0, tier: 1}, 2 => %{delta: -2, tier: 1}}} == Tier.assign_deltas({result, record})
  end
end