ExUnit.start

Mix.Task.run "ecto.create", ~w(-r MemoApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r MemoApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(MemoApi.Repo)

