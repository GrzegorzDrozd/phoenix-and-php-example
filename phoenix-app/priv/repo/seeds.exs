# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixApp.Repo.insert!(%PhoenixApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixApp.Repo
alias PhoenixApp.User

Repo.insert!(%User{
  first_name: "John",
  last_name: "Doe",
  birthdate: ~D[1990-01-01],
  gender: "male"
})

Repo.insert!(%User{
  first_name: "Jane",
  last_name: "Doe",
  birthdate: ~D[1992-03-15],
  gender: "female"
})
