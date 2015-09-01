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

  def signup(changeset) do
    if changeset.valid? do
      user = Repo.insert!(changeset)
      {:ok, user}
    else
      {:error, changeset}
    end
  end

  def set_encrypted_password(changeset) do
    password = Ecto.Changeset.get_field(changeset, :password)
    change(changeset, %{encrypted_password: Comeonin.Bcrypt.hashpwsalt(password)})
  end
end
