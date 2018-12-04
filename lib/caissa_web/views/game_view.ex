defmodule CaissaWeb.GameView do
  use CaissaWeb, :view

  def maybe_fen(positions, move_index) do
    position = Enum.at(positions, move_index)
    if position do
      position.fen
    end
  end
end
