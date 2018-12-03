defmodule CaissaWeb.PageController do
  use CaissaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
