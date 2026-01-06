defmodule PhoenixAppWeb.UserView do
  use PhoenixAppWeb, :view

  def render("index.json", %{users: users, total_count: total_count, current_page: current_page}) do
    %{
      data: render_many(users, __MODULE__, "user.json", as: :user),
      total_count: total_count,
      current_page: current_page
    }
  end

  def render("show.json", %{user: user}) do
    render_one(user, __MODULE__, "user.json", as: :user)
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      birthdate: user.birthdate,
      gender: user.gender,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
