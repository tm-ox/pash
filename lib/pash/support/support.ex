defmodule Pash.Support do
  use Ash.Domain,
    extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Pash.Support.Ticket
    resource Pash.Support.Representative
  end
end
