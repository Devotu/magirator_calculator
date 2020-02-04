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


      # assert [
      # %{count: 1, colors: {:black}},
      # %{count: 1, colors: {:red, :blue}},
      # %{count: 2, colors: {:black, :green}},
      # %{count: 1, colors: {:black, :white, :green}},
      # ] == MagiratorCalculator.count_color_composition(decks)


  def count_color_composition(decks) when is_list decks do
    count_combos(decks, %{})
  end


  defp split_to_atoms(key) do
    String.split(key, "_")
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
  end


  defp count_combos([], count) do
    count
  end

  defp count_combos([h|t], count) do
    combo_name = combo(h)
    count = increment_key(count, combo_name)
    count_combos(t, count)
  end


  defp increment_key(map, key) do
    case Map.has_key? map, key do
      :true ->
        Map.put(map, key, map[key] + 1)
      _ -> 
        Map.put(map, key, 1)
    end
  end


  #All
  defp combo(%{black: :true, white: :true, red: :true, green: :true, blue: :true}), do: :black_white_red_green_blue

  #Quads
  defp combo(%{black: :true, white: :true, red: :true, green: :true}), do: :black_white_red_green
  defp combo(%{black: :true, white: :true, red: :true, blue: :true}), do: :black_white_red_blue
  defp combo(%{black: :true, white: :true, green: :true, blue: :true}), do: :black_white_green_blue
  defp combo(%{black: :true, red: :true, green: :true, blue: :true}), do: :black_red_green_blue
  defp combo(%{white: :true, red: :true, green: :true, blue: :true}), do: :white_red_green_blue

  #Triplets
  defp combo(%{black: :true, white: :true, red: :true}), do: :black_white_red
  defp combo(%{black: :true, white: :true, green: :true}), do: :black_white_green
  defp combo(%{black: :true, white: :true, blue: :true}), do: :black_white_blue
  defp combo(%{black: :true, red: :true, green: :true}), do: :black_red_green
  defp combo(%{black: :true, red: :true, blue: :true}), do: :black_red_blue
  defp combo(%{black: :true, green: :true, blue: :true}), do: :black_green_blue
  defp combo(%{white: :true, red: :true, green: :true}), do: :white_red_green
  defp combo(%{white: :true, red: :true, blue: :true}), do: :white_red_blue
  defp combo(%{white: :true, green: :true, blue: :true}), do: :white_red_blue
  defp combo(%{red: :true, green: :true, blue: :true}), do: :red_red_blue

  #Dual
  defp combo(%{black: :true, white: :true}), do: :black_white
  defp combo(%{black: :true, red: :true}), do: :black_red
  defp combo(%{black: :true, green: :true}), do: :black_green
  defp combo(%{black: :true, blue: :true}), do: :black_blue
  defp combo(%{white: :true, red: :true}), do: :white_red
  defp combo(%{white: :true, green: :true}), do: :white_green
  defp combo(%{white: :true, blue: :true}), do: :white_blue
  defp combo(%{red: :true, green: :true}), do: :red_green
  defp combo(%{red: :true, blue: :true}), do: :red_blue
  defp combo(%{green: :true, blue: :true}), do: :green_blue

  #Mono
  defp combo(%{black: :true}), do: :black
  defp combo(%{white: :true}), do: :white
  defp combo(%{red: :true}), do: :red
  defp combo(%{green: :true}), do: :green
  defp combo(%{blue: :true}), do: :blue

  #None
  defp combo(%{}), do: :colorless
end