defmodule CaissaWeb.Schema.ViewerTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias CaissaWeb.Resolvers.{EcoResolver, ChessResolver}

  object :viewer do
    connection field :categories, node_type: :category do
      arg :code, :string
      resolve &EcoResolver.list_categories/3
    end

    connection field :sub_categories, node_type: :sub_category do
      arg :description, :string
      arg :zobrist_hash, :string
      resolve &EcoResolver.list_sub_categories/3
    end

    field :category, type: :category do
      arg :id, non_null(:integer)
      resolve &EcoResolver.find_category/2
    end

    field :sub_category, type: :sub_category do
      arg :id, non_null(:integer)
      resolve &EcoResolver.find_sub_category/2
    end

    connection field :players, node_type: :player do
      arg :order, type: :sort_order, default_value: :asc
      arg :name, :string
      resolve &ChessResolver.list_players/3
    end

    connection field :games, node_type: :game do
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :game_filter
      resolve &ChessResolver.list_games/3
    end

    connection field :positions, node_type: :position do
      arg :filter, :position_filter
      resolve &ChessResolver.list_positions/3
    end

    field :player, type: :player do
      arg :id, non_null(:integer)
      resolve &ChessResolver.find_player/2
    end

    field :game, type: :game do
      arg :id, non_null(:integer)
      resolve &ChessResolver.find_game/2
    end

    field :position, type: :position do
      arg :id, non_null(:integer)
      resolve &ChessResolver.find_position/2
    end
  end
end
