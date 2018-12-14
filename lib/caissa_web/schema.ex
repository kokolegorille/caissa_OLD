defmodule CaissaWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  require Logger

  # Include date type
  import_types Absinthe.Type.Custom
  import_types __MODULE__.ViewerTypes
  import_types __MODULE__.EcoTypes
  import_types __MODULE__.ChessTypes

  alias CaissaWeb.Resolvers.{ChessResolver, EcoResolver}
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
    field :viewer, type: :viewer do
      resolve fn _, _ -> {:ok, %{}} end
    end

    node field do
      resolve fn
        %{type: :category, id: id}, _ ->
          EcoResolver.find_category(%{id: id}, %{})
        %{type: :sub_category, id: id}, _ ->
          EcoResolver.find_sub_category(%{id: id}, %{})
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
end
