defmodule CaissaWeb.Schema.EcoTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Ecto, repo: ChessDb.Repo

  alias CaissaWeb.Resolvers.EcoResolver

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
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection node_type: :category

  node object :sub_category do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :code, :string
    field :description, :string
    field :pgn, :string
    field :fen, :string
    field :zobrist_hash, :bigint

    field :category, :category, resolve: assoc(:category)

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  connection node_type: :sub_category

  # PRIVATE
  # ==============================

  # Extract internal id from context source
  defp resolve_internal_id(_args, %{source: source}),
    do: {:ok, source.id}
  defp resolve_internal_id(_args, _context), do: {:ok, nil}
end
