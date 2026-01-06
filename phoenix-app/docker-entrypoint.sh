#!/bin/bash
set -e

# Create the database if it doesn't exist
mix ecto.create || true

# Run migrations
mix ecto.migrate

# Run seeds
mix db.seed

# Start the application
# exec mix phx.server
exec elixir --name debug@0.0.0.0 --cookie mysecretcookie -S mix phx.server
