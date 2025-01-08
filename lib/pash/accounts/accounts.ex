defmodule Pash.Accounts do
  use Ash.Domain,
    extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Pash.Accounts.Token
    resource Pash.Accounts.User
  end
end
