defmodule DoctorSchedule.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DoctorSchedule.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "someemail@email.com",
        first_name: "some first_name",
        last_name: "some last_name",
        password: "somepassword",
        password_confirmation: "somepassword",
        role: "some role"
      })
      |> DoctorSchedule.Accounts.Repositories.Account.create_user()

    user
  end
end
