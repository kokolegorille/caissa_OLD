defmodule CaissaWeb.GameController do
  use CaissaWeb, :controller
  require Logger

  alias ChessDb.{Chess, Repo}

  @allowed_filter_keys ~w(
    event site round result year
    white_player black_player player zobrist_hash
  )

  def index(conn, params) do
    filter = sanitize_params(params)
    games = Chess.list_games(%{order: :desc, filter: filter})
    render(conn, "index.html", games: games, filter: filter)
  end

  def show(conn, %{"id" => id} = params) do
    game = Chess.get_game!(id)
    |> Repo.preload([:white_player, :black_player])

    positions = Chess.list_game_positions(game)
    moves = Enum.map(positions, & &1.move)

    move_index = params
    |> Map.get("move_index", "0")
    |> String.to_integer

    render(conn, "show.html",
      game: game,
      positions: positions,
      moves: moves,
      move_index: move_index
    )
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
