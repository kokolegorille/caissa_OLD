defmodule CaissaWeb.GameController do
  use CaissaWeb, :controller

  alias ChessDb.{Chess, Repo}

  def index(conn, %{"zobrist" => zobrist}) do
    games = Chess.list_games_by_zobrist_hash(zobrist)
    render(conn, "index.html", games: games)
  end

  def index(conn, _params) do
    games = Chess.list_games
    render(conn, "index.html", games: games)
  end

  def show(conn, %{"id" => id} = params) do
    game = Chess.get_game!(id)
    |> Repo.preload([:white_player, :black_player])

    positions = Chess.list_game_positions(game)
    moves = Enum.map(positions, & &1.move)

    move_index = params
    |> Map.get("move_index", "0")
    |> String.to_integer

    render(conn, "show.html", game: game, positions: positions, moves: moves, move_index: move_index)
  end
end
