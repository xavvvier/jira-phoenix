defmodule Jira.LoginController do
  use Jira.Web, :controller

  def index(conn, %{"server" => server}) do
    user = %Jira.User{server: server}
    render conn, "index.html", user: user
  end

  def create(conn, %{ "url" => "", "server" => server}) do
    conn
    |> put_flash(:info, "Invalid url")
    |> redirect(to: login_path(conn, :index, server))
  end
  def create(conn, %{ "url" => custom_url, "server" => server, "userName" => userName, "password" => pass }) do
    user = %JiraUser{user: userName, server: custom_url, pass: pass}
    login conn, user, server
  end
  def create(conn, %{ "server" => server, "userName" => userName, "password" => pass }) do
    url = server_url(server)
    user = %JiraUser{user: userName, server: url, pass: pass}
    login conn, user, server
  end

  defp login(conn, %JiraUser{}=user, server) do
    jira_user = JiraLog.myself(user)
    IO.puts "user:"
    IO.inspect user
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
        conn = put_session(conn, :usr, merged_user)
        redirect conn, to: "/worklog"
    end
  end

  defp server_url(server_name) do
    servers = Application.get_env(:jira, :servers)
    servers
    |> Enum.filter(fn x -> x.name == server_name end)
    |> Enum.at(0)
    |> Map.fetch!(:url)
  end

end
