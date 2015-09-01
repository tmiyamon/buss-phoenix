defmodule BussPhoenix.PageController do
  use BussPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
