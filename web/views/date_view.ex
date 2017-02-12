defmodule Scripture.DateView do
  use Scripture.Web, :view

  alias Calendar.DateTime

  def formatted_datetime(naive_date_time, target_timezone \\ "CET") do
    {:ok, utc_date_time} = DateTime.from_naive(naive_date_time, "UTC")
    {:ok, date_time} = DateTime.shift_zone(utc_date_time, target_timezone)
    "#{formatted_integer date_time.day}.#{formatted_integer date_time.month}." <>
    "#{date_time.year}, " <>
    "#{formatted_integer date_time.hour}:#{formatted_integer date_time.minute}"
  end

  defp formatted_integer(number, digits \\ 2) do
    :io_lib.format "~#{digits}..0B", [number]
  end
end
