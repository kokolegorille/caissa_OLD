defmodule CaissaWeb.Schema do
  use Absinthe.Schema

  import_types CaissaWeb.Schema.Types

  query do
    import_fields :categories
    import_fields :sub_categories
    import_fields :players
    import_fields :games
    import_fields :positions
  end
end
