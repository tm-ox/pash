defmodule Pash.Repo.Migrations.Initial do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_sqlite.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:tickets, primary_key: false) do
      add :representative_id,
          references(:representatives,
            column: :id,
            name: "tickets_representative_id_fkey",
            type: :uuid
          )

      add :status, :text, null: false
      add :subject, :text, null: false
      add :id, :uuid, null: false, primary_key: true
    end

    create table(:representatives, primary_key: false) do
      add :name, :text
      add :id, :uuid, null: false, primary_key: true
    end
  end

  def down do
    drop table(:representatives)

    drop constraint(:tickets, "tickets_representative_id_fkey")

    drop table(:tickets)
  end
end