defmodule PhoenixAppWeb.Plugs.ApiTokenAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- token == System.get_env("API_TOKEN") do
      conn
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> text("Unauthorized")
        |> halt()
    end
  end
end
