defmodule BussPhoenix.Router do
  use BussPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BussPhoenix do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/logout", SessionController, :delete, as: :logout
    get "/signup", SignupController, :new, as: :signup
    post "/signup", SignupController, :create, as: :signup

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BussPhoenix do
  #   pipe_through :api
  # end
end
