defmodule CaissaWeb.Resolvers.ChessResolver do
  @moduledoc """
  The Chess Resolver
  """

  alias Absinthe.Relay.Connection
  alias ChessDb.Chess

  # FINDS
  # =============================

  def find_player(%{id: id}, _info) do
    case Chess.get_player(id) do
      nil -> {:error, "Player id #{id} not found"}
      player -> {:ok, player}
    end
  end

  def find_game(%{id: id}, _info) do
    case Chess.get_game(id) do
      nil -> {:error, "Game id #{id} not found"}
      game -> {:ok, game}
    end
  end

  def find_position(%{id: id}, _info) do
    case Chess.get_position(id) do
      nil -> {:error, "Position id #{id} not found"}
      position -> {:ok, position}
    end
  end

  # LISTS
  # =============================

  def list_players(_, args, _) do
    Chess.list_players_query(args)
    |> Connection.from_query(&Chess.process_repo/1, args)
  end

  def list_games(_, args, _) do
    Chess.list_games_query(args)
    |> Connection.from_query(&Chess.process_repo/1, args)
  end

  def list_positions(_, args, _) do
    Chess.list_positions_query(args)
    |> Connection.from_query(&Chess.process_repo/1, args)
  end

  def list_player_games(_, args, %{source: player}) do
    Chess.list_player_games_query(player, args)
    |> Connection.from_query(&Chess.process_repo/1, args)
  end

  def list_game_positions(_, args, %{source: game}) do
    # Chess.list_game_positions_query(game, args)
    # |> Connection.from_query(&Chess.process_repo/1, args)
    positions = Chess.list_game_positions(game, args)
    {:ok, positions}
  end
end
