defmodule PhoenixApp.Users do
  import Ecto.Query, warn: false
  alias PhoenixApp.Repo
  alias PhoenixApp.User

  @page_size 25

  def list_users(params) do
    query = compose_query(User, params)
    total_count = Repo.aggregate(query, :count)

    page =
      params["page"]
      |> (fn
            nil -> "0"
            s -> s
          end).()
      |> String.to_integer()
      |> max(0)

    offset = page * @page_size

    users =
      query
      |> limit(@page_size)
      |> offset(^offset)
      |> Repo.all()

    {:ok, users, total_count, page}
  end

  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  defp compose_query(query, params) do
    query
    |> search_by_name(params["search"])
    |> filter_by_birthdate(params["birthdate_from"], params["birthdate_to"])
    |> sort_by(params["sort_by"], params["sort_order"])
  end

  defp search_by_name(query, nil), do: query

  defp search_by_name(query, search_term) do
    wildcard_search = "%#{search_term}%"

    where(
      query,
      [u],
      ilike(u.first_name, ^wildcard_search) or ilike(u.last_name, ^wildcard_search)
    )
  end

  defp filter_by_birthdate(query, from, to) do
    with {:ok, from_date} <- Date.from_iso8601(from || ""),
         {:ok, to_date} <- Date.from_iso8601(to || "") do
      where(query, [u], u.birthdate >= ^from_date and u.birthdate <= ^to_date)
    else
      # Ignore invalid date formats
      _ -> query
    end
  end

  defp sort_by(query, nil, _), do: query

  defp sort_by(query, sort_by, sort_order) do
    sort_order = if sort_order == "desc", do: :desc, else: :asc
    # Ensure sort_by is a valid field to prevent SQL injection
    if sort_by in ["first_name", "last_name", "birthdate", "gender", "inserted_at", "updated_at"] do
      order_by(query, [u], [{^sort_order, field(u, ^String.to_atom(sort_by))}])
    else
      # Ignore invalid sort_by values
      query
    end
  end
end
