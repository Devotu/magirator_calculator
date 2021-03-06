defmodule TierTest do
  use ExUnit.Case

  alias MagiratorCalculator.Tier, as: Tier

  @tag init: true
  test "initialize record from list" do
    results = [                                                      #  0  0:  0  0:  0  0:  0  0:
      %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2}, # +1  0: -1  0:  0  0:  0  0:
      %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2}, # +2 >1: -2>-1:  0  0:  0  0:
      %{deck_id_first: 3, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1:  0 -1: +1  0: -1  0:
      %{deck_id_first: 3, place_first: 1, deck_id_second: 4, place_second: 2}, #  0  1:  0 -1: +2 >1: -2>-1:
    ]

    assert %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}, 3 => %{delta: 0, tier: 0}, 4 => %{delta: 0, tier: 0}} == Tier.init_record(results)
  end

  @tag init: true
  test "initialize record from specific" do
    deck_first = %{id: 1, tier: 1, delta: 1}
    deck_second = %{id: 2, tier: 1, delta: -1}

    assert %{1 => %{delta: 1, tier: 1}, 2 => %{delta: -1, tier: 1}} == Tier.init_record(deck_first, deck_second)
  end

  @tag init: true
  test "construct result from whatever" do
    result_first = %{ 
      player_id: 10, 
      game_id: 40,
      deck_id: 20,
      place: 1,
      comment: "As results look like when stored"
    }

    result_second = %{ 
      player_id: 12, 
      game_id: 40,
      deck_id: 23,
      place: 2
    }

    constructed_result = Tier.construct_result(result_first.game_id, result_first.deck_id, result_first.place, result_second.deck_id, result_second.place)
    assert %{game_id: 40, deck_id_first: 20, place_first: 1, deck_id_second: 23, place_second: 2} == constructed_result
  end


  @tag validate: true
  test "validate record true" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}}

    assert {result, record} == Tier.validate({result, record})
  end

  @tag validate: true
  test "validate record false" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 1}, 2 => %{delta: 0, tier: 0}}

    assert {{:invalid, :tier_mismatch}, record} == Tier.validate({result, record})
  end


  @tag assign: true
  test "assign 0/0 -> 1/-1" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 0, tier: 0}}

    assert {result, %{1 => %{delta: 1, tier: 0}, 2 => %{delta: -1, tier: 0}}} == Tier.assign_deltas({result, record})
  end

  @tag assign: true
  test "assign -1/1 -> -2/2" do
    result = %{deck_id_first: 1, place_first: 2, deck_id_second: 2, place_second: 1} # -1  0: +1  0:  0  0:  0  0:
    record = %{1 => %{delta: -1, tier: -1}, 2 => %{delta: 1, tier: -1}}

    assert {result, %{1 => %{delta: -2, tier: -1}, 2 => %{delta: 2, tier: -1}}} == Tier.assign_deltas({result, record})
  end

  @tag assign: true
  test "assign -1/-1 -> 0/-2" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: -1, tier: 1}, 2 => %{delta: -1, tier: 1}}

    assert {result, %{1 => %{delta: 0, tier: 1}, 2 => %{delta: -2, tier: 1}}} == Tier.assign_deltas({result, record})
  end

  @tag shift: true
  test "assign - +max - (1/2)=>(1/2)" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 1, tier: 2}, 2 => %{delta: 1, tier: 2}}

    assert {result, %{1 => %{delta: 1, tier: 2}, 2 => %{delta: 0, tier: 2}}} == Tier.assign_deltas({result, record})
  end

  @tag shift: true
  test "assign - -max - (-1/-2)=>(-1/-2)" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 0, tier: -2}, 2 => %{delta: -1, tier: -2}}

    assert {result, %{1 => %{delta: 1, tier: -2}, 2 => %{delta: -1, tier: -2}}} == Tier.assign_deltas({result, record})
  end


  @tag shift: true
  test "shift - one each - 0/0 -> 1/-1" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 2, tier: 0}, 2 => %{delta: -2, tier: 0}}

    assert {result, %{1 => %{delta: 0, tier: 1}, 2 => %{delta: 0, tier: -1}}} == Tier.shift_tiers({result, record})
  end

  @tag shift: true
  test "shift - one shift - -1/-1 -> 0/-1" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 2, tier: -1}, 2 => %{delta: 1, tier: -1}}

    assert {result, %{1 => %{delta: 0, tier: 0}, 2 => %{delta: 1, tier: -1}}} == Tier.shift_tiers({result, record})
  end


  @tag output: true
  test "only record output" do
    result = %{deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2} # +1  0: -1  0:  0  0:  0  0:
    record = %{1 => %{delta: 2, tier: -1}, 2 => %{delta: 1, tier: -1}}

    assert record == Tier.record_output({result, record})
  end
end
