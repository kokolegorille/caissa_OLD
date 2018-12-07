defmodule CaissaWeb.Resolvers.EcoResolver do
  @moduledoc """
  The Eco Resolver
  """

  alias ChessDb.Eco

  def list_categories(_, args, _) do
    {:ok, Eco.list_categories(args)}
  end

  def list_sub_categories(_, args, _) do
    {:ok, Eco.list_sub_categories(args)}
  end

  def list_category_sub_categories(_, args, %{source: category}) do
    {:ok, Eco.list_category_sub_categories(category, args)}
  end
end
