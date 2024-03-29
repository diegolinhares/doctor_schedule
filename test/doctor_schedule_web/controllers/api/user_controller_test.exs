defmodule DoctorScheduleWeb.Api.UserControllerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorSchedule.AccountsFixtures

  alias DoctorSchedule.Accounts.Entities.User

  @create_attrs %{
    email: "someemail@email.com",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "somepassword",
    password_confirmation: "somepassword",
    role: "some role"
  }
  @update_attrs %{
    email: "someupdatedemail@email.com",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    password: "somepassword",
    password_confirmation: "somepassword",
    role: "some updated role"
  }
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password_hash: nil, role: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.api_user_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "someemail@email.com",
               "first_name" => "some first_name",
               "last_name" => "some last_name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "someupdatedemail@email.com",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.api_user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
