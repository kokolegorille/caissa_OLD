defmodule CaissaWeb.Resolvers.ChessResolver do
  @moduledoc """
  The Chess Resolver
  """

  alias ChessDb.Chess

  def list_players(_, args, _) do
    {:ok, Chess.list_players(args)}
  end

  def list_games(_, args, _) do
    {:ok, Chess.list_games(args)}
  end

  def list_positions(_, args, _) do
    {:ok, Chess.list_positions(args)}
  end

  def list_player_games(_, args, %{source: player}) do
    {:ok, Chess.list_player_games(player, args)}
  end

  def list_game_positions(_, args, %{source: game}) do
    {:ok, Chess.list_game_positions(game, args)}
  end
end
