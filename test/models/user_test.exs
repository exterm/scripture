defmodule Scripture.UserTest do
  use Scripture.ModelCase, async: true

  alias Scripture.User

  @valid_attrs %{email: "some content", first_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset without attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset doesn't change role" do
    reader = build_fixture(:user)
    changeset = User.changeset(reader, %{role: "admin"})

    assert {:ok, "reader"} = Ecto.Changeset.fetch_change(changeset, :role)
  end

  test "admin_changeset does change role" do
    reader = build_fixture(:user)
    changeset = User.admin_changeset(reader, %{role: "admin"})

    assert changeset.valid?
    assert {:ok, "admin"} = Ecto.Changeset.fetch_change(changeset, :role)
  end

  test "admin_changeset doesn't change into invalid role" do
    reader = build_fixture(:user)
    changeset = User.admin_changeset(reader, %{role: "edwin"})

    refute changeset.valid?
  end

  test "generating a new login token" do
    timestamp = %DateTime{calendar: Calendar.ISO, day: 17, hour: 0, microsecond: {178597, 6},
                          minute: 29, month: 10, second: 58, std_offset: 0, time_zone: "Etc/UTC",
                          utc_offset: 0, year: 2016, zone_abbr: "UTC"}
    expected_params = %{
      login_token: "08AAEF4A776132717CEEF5F0DDCDD850EFF763B10845303D1593BA0CD14EE4299213BC499E741" <>
                   "9507F6C1E0CD5C6F657AD09CB10CC2EB45838B1BCB420871813",
      login_token_created_at: timestamp
    }
    params = User.new_login_token(timestamp)
    assert expected_params == params
  end
end
