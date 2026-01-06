defmodule PhoenixAppWeb.UserController do
  use PhoenixAppWeb, :controller

  alias PhoenixApp.Users
  alias PhoenixApp.User

  def index(conn, params) do
    {:ok, users, total_count, page} = Users.list_users(params)

    conn
    |> put_view(PhoenixAppWeb.UserView)
    |> render("index.json", users: users, total_count: total_count, current_page: page)
  end

  def create(conn, params) do
    user_params = params

    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> put_view(PhoenixAppWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      {:ok, user} ->
        conn
        |> put_view(PhoenixAppWeb.UserView)
        |> render("show.json", user: user)

      {:error, :not_found} ->
        handle_not_found(conn)
    end
  end

  def update(conn, %{"id" => id} = params) do
    user_params = Map.drop(params, ["id"])

    with {:ok, %User{} = user} <- Users.get_user(id),
         {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      conn
      |> put_view(PhoenixAppWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get_user(id),
         {:ok, _user} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp handle_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(json: PhoenixAppWeb.ErrorJSON)
    |> render(:"404")
  end
end
