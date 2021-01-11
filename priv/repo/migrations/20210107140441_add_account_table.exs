defmodule HelloFinance.Repo.Migrations.AddAccountTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :integer
      add :code, :string
      add :user_id, references(:users)
      timestamps()
    end
  end
end
