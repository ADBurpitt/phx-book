defmodule Hmm.Repo do
  use Ecto.Repo,
    otp_app: :hmm,
    adapter: Ecto.Adapters.Postgres
end
