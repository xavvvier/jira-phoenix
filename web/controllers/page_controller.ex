defmodule Jira.PageController do
  use Jira.Web, :controller

  def index(conn, _params) do
    servers = Application.get_env(:jira, :servers, [])
    render conn, "index.html", servers: servers
  end

end
