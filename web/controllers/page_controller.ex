defmodule Ombib.PageController do
  use Ombib.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
