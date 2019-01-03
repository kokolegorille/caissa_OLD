defmodule CaissaWeb.Schema.ChessTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Ecto, repo: ChessDb.Repo

  alias CaissaWeb.Resolvers.ChessResolver

  # OBJECTS
  # ==============================

  node object :player do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :last_name, :string
    field :first_name, :string

    connection field :games, node_type: :game do
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :game_filter
      resolve &ChessResolver.list_player_games/3
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection node_type: :player

  node object :game do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :pgn, :string
    field :game_info, :json
    field :event, :string
    field :site, :string
    field :round, :string
    # Enum types cannot start with a digit! (1-0 1/2-1/2 0-1) are not valid :-(
    field :result, :string
    field :year, :integer
    field :month, :integer
    field :day, :integer
    field :white_elo, :integer
    field :black_elo, :integer

    field :black_player, :player, resolve: assoc(:black_player)
    field :white_player, :player, resolve: assoc(:white_player)

    field :positions, list_of(:position) do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string

      resolve &ChessResolver.list_game_positions/3
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection node_type: :game

  node object :position do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :move_index, :integer
    field :fen, :string
    field :zobrist_hash, :bigint
    field :move, :string

    field :game, :game, resolve: assoc(:game)

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection node_type: :position

  # INPUT OBJECT
  # ==============================
  input_object :game_filter do
    field :event, :string
    field :site, :string
    field :round, :string
    field :result, :string
    field :year, :integer
    field :white_player, :string
    field :black_player, :string
    # White or Black player
    field :player, :string
    field :zobrist_hashes, list_of(:string)
  end

  input_object :position_filter do
    field :fen, :string
    field :move, :string
    field :zobrist_hash, :string
  end

  # PRIVATE
  # ==============================

  # Extract internal id from context source
  defp resolve_internal_id(_args, %{source: source}),
    do: {:ok, source.id}
  defp resolve_internal_id(_args, _context), do: {:ok, nil}
end
