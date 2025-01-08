defmodule Pash.Repo.Migrations.Auth do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_sqlite.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :hashed_password, :text, null: false
      add :email, :citext, null: false
      add :id, :uuid, null: false, primary_key: true
      add :confirmed_at, :utc_datetime_usec
    end

    create unique_index(:users, [:email], name: "users_unique_email_index")

    create table(:tokens, primary_key: false) do
      add :updated_at, :utc_datetime_usec, null: false
      add :inserted_at, :utc_datetime_usec, null: false
      add :extra_data, :map
      add :purpose, :text, null: false
      add :expires_at, :utc_datetime, null: false
      add :subject, :text, null: false
      add :jti, :text, null: false, primary_key: true
      add :id, :uuid, null: false, primary_key: true
      add :created_at, :utc_datetime_usec, null: false
    end
  end

  def down do
    drop table(:tokens)

    drop_if_exists unique_index(:users, [:email], name: "users_unique_email_index")

    drop table(:users)
  end
end