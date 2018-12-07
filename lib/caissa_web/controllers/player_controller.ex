defmodule CaissaWeb.PlayerController do
  use CaissaWeb, :controller

  alias ChessDb.{Chess, Repo}

  def index(conn, _params) do
    players = Chess.list_players(order: :asc)
    render(conn, "index.html", players: players)
  end

  def show(conn, %{"id" => id}) do
    player = Chess.get_player!(id)
    games = Chess.list_player_games(player)
    |> Repo.preload([:white_player, :black_player])
    render(conn, "show.html", player: player, games: games)
  end
end
