defmodule PhoenixAppWeb.ImportController do
  use PhoenixAppWeb, :controller
  alias PhoenixApp.ImportManager

  def create(conn, _params) do
    case ImportManager.start_import() do
      :ok ->
        conn
        |> put_status(:accepted)
        |> json(%{status: "Import started"})

      {:error, :already_in_progress} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Import already in progress"})
    end
  end

  def show(conn, _params) do
    status =
      ImportManager.get_status()
      |> prepare_for_json()

    json(conn, status)
  end

  defp prepare_for_json(status) do
    case status.result do
      {:ok, count} ->
        Map.put(status, :result, %{count: count})

      _ ->
        status
    end
  end
end
