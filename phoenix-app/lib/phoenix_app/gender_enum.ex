defmodule PhoenixApp.GenderEnum do
  use Ecto.Type
  def type, do: :gender_enum

  def cast("male"), do: {:ok, "male"}
  def cast("female"), do: {:ok, "female"}
  def cast(_), do: :error

  def load(value), do: {:ok, value}
  def dump(value), do: {:ok, value}
end
