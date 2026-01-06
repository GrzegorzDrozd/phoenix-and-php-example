defmodule PhoenixApp.Importer do
  require Logger
  alias PhoenixApp.Repo
  alias PhoenixApp.User

  def import do
    config = Application.get_env(:phoenix_app, PhoenixApp.Importer)

    case import_users(config[:female_first_names_url], config[:female_last_names_url], "female") do
      {:error, message} ->
        {:error, message}

      female_count ->
        case import_users(config[:male_first_names_url], config[:male_last_names_url], "male") do
          {:error, message} ->
            {:error, message}

          male_count ->
            total_count = female_count + male_count
            Logger.info("Import completed. Total users imported: #{total_count}")
            {:ok, total_count}
        end
    end
  end

  defp import_users(first_names_url, last_names_url, gender) do
    with {:ok, first_names_body} <- download_and_parse_csv(first_names_url),
         {:ok, last_names_body} <- download_and_parse_csv(last_names_url) do
      first_names = get_top_100_first_name(first_names_body)
      last_names = get_top_100_last_name(last_names_body)

      if first_names == [] or last_names == [] do
        message = "One or both name lists are empty after parsing. Aborting user generation."
        Logger.error(message)
        {:error, message}
      else
        users = generate_users(first_names, last_names, gender)
        {count, _} = Repo.insert_all(User, users)
        count
      end
    else
      {:error, message} -> {:error, message}
    end
  end

  defp download_and_parse_csv(url) do
    Logger.info("Downloading CSV from #{url}")

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        Logger.debug("Downloaded CSV content.")
        {:ok, body}

      {:ok, %{status: status}} ->
        message =
          "Failed to download CSV from #{url}. Status: #{status}. Please check the URL in config/config.exs."

        Logger.error(message)
        {:error, message}

      {:error, reason} ->
        message =
          "Network error while downloading CSV from #{url}: #{inspect(reason)}. Please check the URL in config/config.exs."

        Logger.error(message)
        {:error, message}
    end
  end

  defp get_top_100_first_name(data) do
    data
    # remove header
    |> Enum.drop(1)
    |> tap(fn _ -> Logger.debug("Converting data") end)
    |> Enum.map(fn
      [name, col2, count] -> [name, col2, String.to_integer(String.trim(count))]
      row -> row
    end)
    |> tap(fn _ -> Logger.debug("Starting sort") end)
    |> Enum.sort_by(fn [_, _, count] -> count end, :desc)
    |> tap(fn _ -> Logger.debug("Sort complete, taking top 100") end)
    |> Enum.take(100)
    |> Enum.map(fn [name, _, _] -> name end)
    |> tap(fn result -> Logger.debug("Final list size: #{length(result)}") end)
  end

  defp get_top_100_last_name(data) do
    data
    # remove header
    |> Enum.drop(1)
    |> tap(fn _ -> Logger.debug("Converting data") end)
    |> Enum.map(fn
      [name, count] -> [name, String.to_integer(String.trim(count))]
      row -> row
    end)
    |> tap(fn _ -> Logger.debug("Starting sort") end)
    |> Enum.sort_by(fn [_, count] -> count end, :desc)
    |> tap(fn _ -> Logger.debug("Sort complete, taking top 100") end)
    |> Enum.take(100)
    |> Enum.map(fn [name, _] -> name end)
    |> tap(fn result -> Logger.debug("Final list size: #{length(result)}") end)
  end

  defp generate_users(first_names, last_names, gender) do
    now_naive = NaiveDateTime.utc_now()
    now_datetime = DateTime.from_naive!(now_naive, "Etc/UTC")
    now_datetime = DateTime.truncate(now_datetime, :second)

    for _ <- 1..100 do
      %{
        first_name: Enum.random(first_names),
        last_name: Enum.random(last_names),
        birthdate: generate_random_birthdate(),
        gender: gender,
        inserted_at: now_datetime,
        updated_at: now_datetime
      }
    end
  end

  defp generate_random_birthdate do
    year = Enum.random(1970..2024)
    month = Enum.random(1..12)
    day = Enum.random(1..Calendar.ISO.days_in_month(year, month))
    Date.new!(year, month, day)
  end
end
