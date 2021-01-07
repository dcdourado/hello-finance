defmodule HelloFinance.Repo.Migrations.AddAccountTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :integer
      add :currency, :string
      add :user_id, references(:users)
    end
  end
end
