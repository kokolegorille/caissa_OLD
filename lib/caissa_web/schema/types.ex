defmodule CaissaWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Ecto, repo: Repo

  # Include date type
  import_types Absinthe.Type.Custom

  alias CaissaWeb.Resolvers.{ChessResolver, EcoResolver}

  # FIELDS
  # ==============================

  object :store do
    connection field :categories, node_type: :category do
      arg :code, :string
      resolve &EcoResolver.list_categories/3
    end

    connection field :sub_categories, node_type: :sub_category do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve &EcoResolver.list_sub_categories/3
    end

    connection field :players, node_type: :player do
      arg :name, :string
      resolve &ChessResolver.list_players/3
    end

    connection field :games, node_type: :game do
      arg :order, type: :sort_order, default_value: :asc
      arg :event, :string
      arg :site, :string
      arg :round, :string
      arg :result, :string
      arg :year, :integer
      arg :white_player, :string
      arg :black_player, :string
      arg :zobrist_hash, :string

      resolve &ChessResolver.list_games/3
    end

    connection field :positions, node_type: :position do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string
      resolve &ChessResolver.list_positions/3
    end
  end

  # OBJECTS
  # ==============================

  node object :category do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :volume, :string
    field :code, :string

    connection field :sub_categories, node_type: :sub_category do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve &EcoResolver.list_category_sub_categories/3
    end

    # Timestamps
    field :inserted_at, :date
    field :updated_at, :date
  end

  connection node_type: :category

  node object :sub_category do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :code, :string
    field :description, :string
    field :pgn, :string
    field :zobrist_hash, :bigint

    # Timestamps
    field :inserted_at, :date
    field :updated_at, :date
  end

  connection node_type: :sub_category

  node object :player do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :last_name, :string
    field :first_name, :string

    connection field :games, node_type: :game do
      arg :order, type: :sort_order, default_value: :asc
      arg :event, :string
      arg :site, :string
      arg :round, :string
      arg :result, :string
      arg :year, :integer
      arg :white_player, :string
      arg :black_player, :string
      arg :zobrist_hash, :string

      resolve &ChessResolver.list_player_games/3
    end

    # Timestamps
    field :inserted_at, :date
    field :updated_at, :date
  end

  connection node_type: :player

  node object :game do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :pgn, :string
    field :game_info, :json
    field :event, :string
    field :site, :string
    field :round, :string
    # Enum types cannot start with a digit!
    field :result, :string
    field :year, :integer

    field :black_player, :player, resolve: assoc(:black_player)
    field :white_player, :player, resolve: assoc(:white_player)

    connection field :positions, node_type: :position do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string

      resolve &ChessResolver.list_game_positions/3
    end

    # Timestamps
    field :inserted_at, :date
    field :updated_at, :date
  end

  connection node_type: :game

  node object :position do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :move_index, :integer
    field :fen, :string
    field :zobrist_hash, :bigint
    field :move, :string

    # Timestamps
    field :inserted_at, :date
    field :updated_at, :date
  end

  connection node_type: :position

  # TYPES
  # ==============================

  enum :sort_order do
    value :asc
    value :asc_nulls_last
    value :asc_nulls_first
    value :desc
    value :desc_nulls_last
    value :desc_nulls_first
  end

  scalar :bigint do
    parse fn input ->
      case input do
        %Absinthe.Blueprint.Input.String{} = _input ->
          :error
        input when is_nil(input) or input == "" ->
          :error
        input ->
          String.to_integer(input)
      end
    end

    serialize &to_string(&1)
  end

  scalar :json do
    parse fn input ->
      case Jason.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end
    serialize &Jason.encode!/1
  end

  # PRIVATE
  # ==============================

  # Extract internal id from context source
  defp resolve_internal_id(_args, %{source: source}),
    do: {:ok, source.id}
  defp resolve_internal_id(_args, _context), do: {:ok, nil}
end
