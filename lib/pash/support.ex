defmodule Pash.Support do
  use Ash.Domain

  resources do
    resource Pash.Support.Ticket
  end
end
