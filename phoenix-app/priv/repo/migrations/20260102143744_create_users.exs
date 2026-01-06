defmodule PhoenixApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE gender_enum AS ENUM ('male', 'female');
    """

    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :birthdate, :date
      add :gender, :gender_enum

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(:users)

    execute """
    DROP TYPE gender_enum;
    """
  end
end
