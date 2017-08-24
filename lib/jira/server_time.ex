defmodule Jira.ServerTime do
  use Timex

  defp now do
    offset_minutes = Application.get_env(:jira, :time_zone_offset, 0)
    Timex.now()
    |> Timex.shift(minutes: offset_minutes)
    |> IO.inspect
  end

  def today() do
    now()
    |> DateTime.to_date
  end

  def yesterday() do
    now()
    |> DateTime.to_date
    |> Timex.shift(days: -1)
  end

  def this_week() do
    beginning = beginning_of_week()
    end_of_week = Timex.shift(beginning, days: 6)
    {beginning, end_of_week}
  end

  def last_week() do
    beginning = beginning_of_last_week()
    end_of_week = Timex.shift(beginning, days: 6)
    {beginning, end_of_week}
  end

  defp beginning_of_week do
    now()
    |> DateTime.to_date
    |> Timex.beginning_of_week
  end

  defp beginning_of_last_week do
    beginning_of_week()
    |> Timex.shift(days: -7)
  end

end
