defmodule CaissaWeb.Schema do
  alias ChessDb.{Eco, Chess, Repo}

  use Absinthe.Schema
  use Absinthe.Ecto, repo: Repo

  query do
    field :categories, list_of(:category) do
      arg :code, :string
      resolve fn _, args, _ -> {:ok, Eco.list_categories(args)} end
    end

    field :sub_categories, list_of(:sub_category) do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve fn _, args, _ -> {:ok, Eco.list_sub_categories(args)} end
    end

    field :players, list_of(:player) do
      arg :name, :string
      resolve fn _, args, _ -> {:ok, Chess.list_players(args)} end
    end

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

    field :positions, list_of(:position) do
      arg :fen, :string
      arg :move, :string
      arg :zobrist_hash, :string
      resolve fn _, args, _ -> {:ok, Chess.list_positions(args)} end
    end
  end

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
    # field :game_info, :map
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
  #     IO.puts "===============> #{inspect input}"
  #     # case String.to_integer(input) do
  #     #   {bigint, _} -> {:ok, bigint}
  #     #   :error -> :error
  #     # end

  #     {:ok, String.to_integer(input)}
  #   end

  #   serialize fn bigint ->
  #     to_string(bigint)
  #   end
  # end
end
