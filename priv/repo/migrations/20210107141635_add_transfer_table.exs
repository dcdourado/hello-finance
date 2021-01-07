defmodule HelloFinance.Repo.Migrations.AddTransferTable do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :value, :integer
      add :currency, :string
      add :sender_account_id, references(:accounts)
      add :receiver_account_id, references(:accounts)
      timestamps()
    end
  end
end
