defmodule Jira.Router do
  use Jira.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jira do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/login/:server", LoginController, only: [:index, :create]
    get "/worklog", WorklogController, :index
    get "/logout", WorklogController, :logout
    get "/today", WorklogController, :today
    get "/yesterday", WorklogController, :yesterday
    get "/thisweek", WorklogController, :this_week
    get "/lastweek", WorklogController, :last_week
    get "/thismonth", WorklogController, :this_month
    get "/lastmonth", WorklogController, :last_month
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jira do
  #   pipe_through :api
  # end
end
