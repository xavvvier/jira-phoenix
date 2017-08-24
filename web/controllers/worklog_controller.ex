defmodule Jira.WorklogController do
  use Jira.Web, :controller
  alias Jira.ServerTime

  plug :authenticate

  defp authenticate(conn, _) do
    case get_session(conn, :usr) do
      nil -> 
        conn
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: "/")
        |> halt()
      _ ->
        conn
    end
  end

  def index(conn, _params) do
    usr = get_session(conn, :usr)
    render conn, "index.html", name: usr.display_name
  end

  def logout(conn, _params) do
    conn
    |> clear_session
    |> redirect(to: "/")
    |> halt()
  end

  def today(conn, _params) do
    today = ServerTime.today()
    filter = %WorklogFilter{
      date_from: today,
      date_to: today}
    conn
    |> assign(:title, "Today")
    |> display(filter)
  end

  def yesterday(conn, _params) do
    yesterday = ServerTime.yesterday()
    filter = %WorklogFilter{
      date_from: yesterday,
      date_to: yesterday}
    conn
    |> assign(:title, "Yesterday")
    |> display(filter)
  end

  def this_week(conn, _params) do
    {beginning, end_of_week} = ServerTime.this_week()
    filter = %WorklogFilter{
      date_from: beginning,
      date_to: end_of_week}
    conn
    |> assign(:title, "This Week")
    |> display(filter)
  end

  def last_week(conn, _params) do
    {beginning, end_of_week} = ServerTime.last_week()
    filter = %WorklogFilter{
      date_from: beginning,
      date_to: end_of_week}
    conn
    |> assign(:title, "Last Week")
    |> display(filter)
  end


  defp display(conn, filter) do
    user = get_session(conn, :usr)
    filter = %{filter | user: user.user}
    logs = JiraLog.list_logs(filter, user)
           |> Enum.group_by(fn item ->
             #group by date and user
             {String.slice(item.started, 0..9), item.user}
           end)
    render conn, "list.html", logs: logs, url: user.server
  end

end
