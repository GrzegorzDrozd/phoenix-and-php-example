defmodule PhoenixApp.ImportManager do
  use GenServer
  require Logger

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_import do
    GenServer.call(__MODULE__, :start_import)
  end

  def get_status do
    GenServer.call(__MODULE__, :get_status)
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, %{status: :idle, result: nil, started_at: nil}}
  end

  @impl true
  def handle_call(:start_import, _from, state) do
    if state.status == :in_progress do
      {:reply, {:error, :already_in_progress}, state}
    else
      # Using Task.async to run the import in a separate process
      Task.async(fn ->
        try do
          PhoenixApp.Importer.import()
        catch
          e, r -> {:error, {e, r}}
        end
      end)

      new_state = %{
        state
        | status: :in_progress,
          result: nil,
          started_at: NaiveDateTime.utc_now()
      }

      {:reply, :ok, new_state}
    end
  end

  @impl true
  def handle_call(:get_status, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({ref, result}, state) when is_reference(ref) do
    Process.demonitor(ref, [:flush])

    case result do
      {:ok, _} ->
        new_state = %{state | status: :completed, result: result}
        {:noreply, new_state}

      {:error, {exception, stacktrace}} ->
        Logger.error("Import failed: #{inspect(exception)}")
        Logger.error("Stacktrace: #{inspect(stacktrace)}")
        new_state = %{state | status: :failed, result: inspect(exception)}
        {:noreply, new_state}

      other ->
        Logger.error("Unknown result from import task: #{inspect(other)}")
        new_state = %{state | status: :failed, result: "Unknown result from import task"}
        {:noreply, new_state}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    # Only update the state if the import was in progress
    if state.status == :in_progress do
      Logger.error("Import task crashed: #{inspect(reason)}")
      new_state = %{state | status: :failed, result: inspect(reason)}
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end
end
