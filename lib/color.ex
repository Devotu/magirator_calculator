defmodule MagiratorCalculator.Color do

  def count_color_occurances(decks) when is_list decks do
    %{
      black: count_black(decks),
      white: count_white(decks),
      red: count_red(decks),
      green: count_green(decks),
      blue: count_blue(decks),
      colorless: count_colorless(decks),
    }
  end


  defp count_black(decks) do
    Enum.count(decks, &(&1.black))
  end

  defp count_white(decks) do
    Enum.count(decks, &(&1.white))
  end

  defp count_red(decks) do
    Enum.count(decks, &(&1.red))
  end

  defp count_green(decks) do
    Enum.count(decks, &(&1.green))
  end

  defp count_blue(decks) do
    Enum.count(decks, &(&1.blue))
  end

  defp count_colorless(decks) do
    Enum.count(decks, &(&1.colorless))
  end
end