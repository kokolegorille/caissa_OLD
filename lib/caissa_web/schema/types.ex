defmodule CaissaWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Repo

  alias ChessDb.{Chess, Eco}

  # FIELDS

  object :categories do
    field :categories, list_of(:category) do
      arg :code, :string
      resolve fn _, args, _ -> {:ok, Eco.list_categories(args)} end
    end
  end

  object :sub_categories do
    field :sub_categories, list_of(:sub_category) do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve fn _, args, _ -> {:ok, Eco.list_sub_categories(args)} end
    end
  end

  object :players do
    field :players, list_of(:player) do
      arg :name, :string
      resolve fn _, args, _ -> {:ok, Chess.list_players(args)} end
    end
  end

  object :games do
    field :games, list_of(:game) do
      arg :order, type: :sort_order, default_value: :asc
      arg :event, :string
      arg :site, :string
      arg :round, :string
      arg :result, :string
      arg :year, :integer
      arg :white_player, :string
      arg :black_player, :string
      arg :zobrist_hash, :string

      resolve fn _, args, _ -> {:ok, Chess.list_games(args)} end
    end
  end

  object :positions do
    field :positions, list_of(:position) do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string
      resolve fn _, args, _ -> {:ok, Chess.list_positions(args)} end
    end
  end

  # OBJECTS

  object :category do
    field :id, :id
    field :volume, :string
    field :code, :string

    field :sub_categories, list_of(:sub_category) do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve fn _, args, %{source: category} -> {:ok, Eco.list_category_sub_categories(category, args)} end
    end
  end

  object :sub_category do
    field :id, :id
    field :code, :string
    field :description, :string
    field :pgn, :string
    field :zobrist_hash, :string
  end

  object :player do
    field :id, :id
    field :last_name, :string
    field :first_name, :string

    field :games, list_of(:game) do
      arg :order, type: :sort_order, default_value: :asc
      arg :event, :string
      arg :site, :string
      arg :round, :string
      arg :result, :string
      arg :year, :integer
      arg :white_player, :string
      arg :black_player, :string
      arg :zobrist_hash, :string

      resolve fn _, args, %{source: player} -> {:ok, Chess.list_player_games(player, args)} end
    end
  end

  object :game do
    field :id, :id
    field :pgn, :string
    field :game_info, :json
    field :event, :string
    field :site, :string
    field :round, :string
    field :result, :string
    field :year, :integer

    field :black_player, :player, resolve: assoc(:black_player)
    field :white_player, :player, resolve: assoc(:white_player)

    field :positions, list_of(:position) do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string
      resolve fn _, args, %{source: game} -> {:ok, Chess.list_game_positions(game, args)} end
    end
  end

  object :position do
    field :id, :id
    field :move_index, :integer
    field :fen, :string
    field :zobrist_hash, :string
    field :move, :string
  end

  # enum :result_type do
  #   value :"1-0"
  #   value :"0-1"
  #   value :"1/2-1/2"
  #   value :"1/2"
  # end

  enum :sort_order do
    value :asc
    value :asc_nulls_last
    value :asc_nulls_first
    value :desc
    value :desc_nulls_last
    value :desc_nulls_first
  end

  # scalar :bigint do
  #   parse fn input ->
  #     case input do
  #       input when is_nil(input) or input == "" ->
  #         :error
  #       input ->
  #         String.to_integer(input)
  #     end
  #   end
  #
  #   serialize &to_string(&1)
  # end

  scalar :json do
    parse fn input ->
      case Jason.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end
    serialize &Jason.encode!/1
  end
end
