defmodule CaissaWeb.SubCategoryController do
  use CaissaWeb, :controller
  require Logger

  alias ChessDb.Eco

  @allowed_filter_keys ~w(
    description zobrist_hash code
  )

  def index(conn, params) do
    filter = sanitize_params(params)
    sub_categories = Eco.list_sub_categories(filter)
    render(conn, "index.html", sub_categories: sub_categories)
  end

  defp sanitize_params(params) do
    params
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      if Enum.member?(@allowed_filter_keys, k) do
        Map.put(acc, String.to_atom(k), v)
      else
        Logger.debug fn -> "filter key not allowed : #{k}" end
        acc
      end
    end)
  end
end
