defmodule PhoenixAppWeb.FallbackController do
  use PhoenixAppWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: PhoenixAppWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PhoenixAppWeb.ErrorJSON)
    |> render(:"422", changeset: changeset)
  end
end
