defmodule CaissaWeb.Resolvers.EcoResolver do
  @moduledoc """
  The Eco Resolver
  """

  alias Absinthe.Relay.Connection
  alias ChessDb.Eco

  # FINDS
  # =============================

  def find_category(%{id: id}, _info) do
    case Eco.get_category(id) do
      nil -> {:error, "Category id #{id} not found"}
      category -> {:ok, category}
    end
  end

  def find_sub_category(%{id: id}, _info) do
    case Eco.get_sub_category(id) do
      nil -> {:error, "SubCategory id #{id} not found"}
      sub_category -> {:ok, sub_category}
    end
  end

  # LISTS
  # =============================

  def list_categories(_, args, _) do
    Eco.list_categories_query(args)
    |> Connection.from_query(&Eco.process_repo/1, args)
  end

  def list_sub_categories(_, args, _) do
    Eco.list_sub_categories_query(args)
    |> Connection.from_query(&Eco.process_repo/1, args)
  end

  def list_category_sub_categories(_, args, %{source: category}) do
    Eco.list_category_sub_categories_query(category, args)
    |> Connection.from_query(&Eco.process_repo/1, args)
  end
end
