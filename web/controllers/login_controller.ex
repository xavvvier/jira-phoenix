defmodule Jira.LoginController do
  use Jira.Web, :controller

  def index(conn, %{"server" => server}) do
    user = %Jira.User{server: server}
    render conn, "index.html", user: user
  end

  @doc """
  Login the user to a custom jira server
  """
  def create(conn, %{ "url" => "", "server" => server}) do
    conn
    |> put_flash(:info, "Invalid url")
    |> redirect(to: login_path(conn, :index, server))
  end
  def create(conn, %{ "url" => custom_url, "server" => server, "userName" => userName, "password" => pass }) do
    user = %JiraUser{user: userName, server: custom_url, pass: pass}
    login conn, user, server
  end

  @doc """
  Login the user to one of the configured jira servers
  """
  def create(conn, %{ "server" => server, "userName" => userName, "password" => pass }) do
    url = server_url(server)
    user = %JiraUser{user: userName, server: url, pass: pass}
    login conn, user, server
  end

  defp login(conn, %JiraUser{}=user, server) do
    jira_user = JiraLog.myself(user)
    case jira_user do
      nil -> 
        conn
        |> put_flash(:info, "Username or password invalid")
        |> redirect(to: login_path(conn, :index, server))
      _ -> 
        merged_user = %{user | 
          avatar: jira_user.avatar, 
          display_name: jira_user.display_name, 
          email_address: jira_user.email_address }
        conn
        |> put_session(:usr, merged_user)
        |> put_server_image(server)
        |> redirect(to: "/worklog")
    end
  end

  defp put_server_image(conn, server_name) do
    server_config = Application.get_env(:jira, :servers)
    |> Enum.filter(fn x -> x.name == server_name end)
    |> Enum.at(0)
    server_icon = cond do
      server_config == nil -> "custom-logo.png"
      true -> server_config.img
    end
    put_session(conn, :server_img, server_icon)
  end

  defp server_url(server_name) do
    servers = Application.get_env(:jira, :servers)
    servers
    |> Enum.filter(fn x -> x.name == server_name end)
    |> Enum.at(0)
    |> Map.fetch!(:url)
  end

end
