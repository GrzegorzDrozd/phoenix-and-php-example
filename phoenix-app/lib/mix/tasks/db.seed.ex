defmodule Mix.Tasks.Db.Seed do
  use Mix.Task

  @shortdoc "Seeds the database if it's empty"
  def run(_) do
    Mix.Task.run("app.start")

    alias PhoenixApp.Repo
    alias PhoenixApp.User

    if Repo.all(User) == [] do
      Mix.Task.run("run", ["priv/repo/seeds.exs"])
    else
      IO.puts("Database already seeded.")
    end
  end
end
