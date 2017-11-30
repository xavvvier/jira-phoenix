defmodule Jira.WorklogController do
  use Jira.Web, :controller
  alias Jira.ServerTime

  plug :authenticate
  plug :put_image

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

  defp put_image(conn, _) do
    server_img = get_session(conn, :server_img)
    assign(conn, :server_img, server_img)
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

  def this_month(conn, _params) do
    {beginning, end_of_month} = ServerTime.this_month()
    filter = %WorklogFilter{
      date_from: beginning,
      date_to: end_of_month}
    conn
    |> assign(:title, "This Month")
    |> display(filter)
  end

  def last_month(conn, _params) do
    {beginning, end_of_month} = ServerTime.last_month()
    filter = %WorklogFilter{
      date_from: beginning,
      date_to: end_of_month}
    conn
    |> assign(:title, "Last Month")
    |> display(filter)
  end

  defp firts_not_nil(nil, b), do: b
  defp firts_not_nil("", b), do: b
  defp firts_not_nil(a, _), do: a

  defp display(conn, filter) do
    user_in_session = get_session(conn, :usr)
    user_query_string = conn.params["u"]
    user_to_query = firts_not_nil(user_query_string, user_in_session.user)
    filter = %{filter | user: user_to_query}
    logs = JiraLog.list_logs(filter, user_in_session)
           |> Enum.group_by(fn item ->
             #group by date and user
             {String.slice(item.started, 0..9), item.user}
           end)
    render conn, "list.html", logs: logs, url: user_in_session.server
  end

end
