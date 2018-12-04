defmodule CaissaWeb.CategoryController do
  use CaissaWeb, :controller

  alias ChessDb.Eco

  def index(conn, _params) do

    categories = Eco.list_categories

    render(conn, "index.html", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    category = Eco.get_category!(id)
    sub_categories = Eco.list_category_sub_categories(category)
    render(conn, "show.html", category: category, sub_categories: sub_categories)
  end
end
