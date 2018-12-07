defmodule CaissaWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  alias CaissaWeb.Resolvers.{ChessResolver, EcoResolver}

  require Logger
  import_types CaissaWeb.Schema.Types

  alias ChessDb.Eco.{Category, SubCategory}
  alias ChessDb.Chess.{Player, Game, Position}

  node interface do
    resolve_type fn
      %Category{}, _ ->
        :category
      %SubCategory{}, _ ->
        :sub_category
      %Player{}, _ ->
        :player
      %Game{}, _ ->
        :game
      %Position{}, _ ->
        :position
      _, _ ->
        nil
    end
  end

  query do
    field :store, type: :store do
      resolve fn _, _ -> {:ok, %{}} end
    end

    node field do
      resolve fn
        # Eco fields

        %{type: :category, id: id}, _ ->
          EcoResolver.find_category(%{id: id}, %{})
        %{type: :sub_category, id: id}, _ ->
          EcoResolver.find_sub_category(%{id: id}, %{})

        # Chess fields

        %{type: :player, id: id}, _ ->
          ChessResolver.find_player(%{id: id}, %{})
        %{type: :game, id: id}, _ ->
          ChessResolver.find_game(%{id: id}, %{})
        %{type: :position, id: id}, _ ->
           ChessResolver.find_position(%{id: id}, %{})
        %{type: type, id: id}, _ ->
          Logger.info "Could not resolve key : #{type} #{id}"
          nil
      end
    end
  end
end
