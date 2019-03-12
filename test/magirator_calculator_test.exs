defmodule MagiratorCalculatorTest do
  use ExUnit.Case
  doctest MagiratorCalculator

  test "calculate points" do
    results = 
      [
        %{comment: "Third result", created: 1552337401729, id: 32, place: 1}, 
        %{comment: "First result", created: 1552337401701, id: 30, place: 1},
      ]

    {:ok, points} = MagiratorCalculator.calculate_points(results)
    assert is_number points
  end
end
