defmodule DoctorSchedule.AccountTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.Account

  describe "users" do
    alias DoctorSchedule.Accounts.Entities.User

    import DoctorSchedule.AccountsFixtures

    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil, password_confirmation: nil, role: nil}

    test "list_users/0 returns all users" do
      user_fixture()
      assert Account.list_users() |> Enum.count() == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "someemail@email.com",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "somepassword_hash",
      password_confirmation: "somepassword_hash",
      role: "some role"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.email == "someemail@email.com"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "someupdatedemail@email.com", first_name: "some updated first_name", last_name: "some updated last_name", password_hash: "some updated password_hash", role: "some updated role"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.email == "someupdatedemail@email.com"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user.email == Account.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
