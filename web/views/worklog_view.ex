defmodule Jira.WorklogView do
  use Jira.Web, :view

  @doc """
  Parses the given seconds to hours and minute format

  ## Examples

    iex> Jira.WorklogView.seconds_to_hours(7200)
    "2h"

    iex> Jira.WorklogView.seconds_to_hours(8100)
    "2h 15m"
  """
  def seconds_to_hours(seconds) do
    hours = div(seconds, 3600)
    minutes = div(rem(seconds, 3600), 60)
    format(hours, minutes)
  end

  defp format(hours, minutes) when minutes > 0 do
    "#{hours}h #{minutes}m" 
  end
  defp format(hours, _minutes) do
    "#{hours}h" 
  end

  def total_time(times) do
    times
    |> Stream.map(&(&1.seconds))
    |> Enum.sum()
    |> seconds_to_hours
  end

  @doc """
  Parses the given iso date string to a user friendly date

  ## Examples

    iex> Jira.WorklogView.format_iso_date("2017-08-22T18:26:00.000-0500")
    "2017-08-22 18:26"

  """
  def format_iso_date(date) do
    String.slice(date, 0..9) <> " " <> String.slice(date, 11..15)
  end

end
