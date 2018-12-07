defmodule CaissaWeb.FileController do
  use CaissaWeb, :controller

  alias ChessDb.Import

  @pgn_mime_type [
    "application/octet-stream",
    "application/x-chess-pgn",
    "application/da-chess-pgn",
    "application/vnd.chess-pgn"
  ]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %{"file" => file_params}}) do
    IO.inspect file_params

    if check_file(file_params) do
      filename = Ksuid.generate()
      file_path = Path.join(:code.priv_dir(:caissa), "storage/#{filename}")

      # Persists temporarily the file
      File.cp(file_params.path, file_path)

      Task.async(fn -> enqueue_file(file_path) end)

      conn
      |> put_flash(:info, "PGN file has been uploaded.")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Please select a valid PGN file.")
      |> render(:new)
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Please select a valid PGN file.")
    |> render(:new)
  end

  # Private

  defp check_file(%{content_type: content_type, filename: filename}) do
    Enum.member?(@pgn_mime_type, content_type) && Path.extname(filename) == ".pgn"
  end
  defp check_file(_file_params), do: false

  defp enqueue_file(file_path) do
    Import.load_pgn(file_path)
    # Remove the file after process
    File.rm(file_path)
  end
end
