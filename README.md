# Jira

To start this phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Configure default servers

Config the application to use some servers by default in `config/dev.exs` or `config/prod.exs`:

`config :jira,
  servers: [
    %{
      url: "https://jira.myserver.com", 
      img: "my-logo.png",
      name: "Internal Server"
    },
    %{
      url: "https://my-company.atlassian.net",
      img: "company-logo.png",
      name: "My Company"
    }
  ]`
