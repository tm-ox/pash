defmodule Pash.Repo.Migrations.Blogimage do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_sqlite.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :image_url, :text
      add :image_alt, :text
    end
  end

  def down do
    alter table(:posts) do
      remove :image_alt
      remove :image_url
    end
  end
end