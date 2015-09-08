defmodule BussPhoenix.User do
  use BussPhoenix.Web, :model

  alias BussPhoenix.User
  alias BussPhoenix.Repo

  before_insert :set_encrypted_password

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def login_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email password), ~w(name))
    |> validate_password
  end

  def set_encrypted_password(changeset) do
    password = Ecto.Changeset.get_field(changeset, :password)
    change(changeset, %{encrypted_password: encrypt_password(password)})
  end

  def encrypt_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  def validate_password(changeset, opts \\ []) do
    validate_change changeset, :password, {:encrypted, opts}, fn _, password ->
      stored_encrypted_password = Ecto.Changeset.get_field(changeset, :encrypted_password)
      if !Comeonin.Bcrypt.checkpw(password, stored_encrypted_password) do
        [{:password, "Wrong email or password"}]
      else
        []
      end
    end
  end

  def by_email(query, email) do
    from u in query,
    where: u.email == ^email
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def signed_in?(conn) do
    !is_nil(current_user(conn))
  end

end
