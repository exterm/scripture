defmodule Scripture.DateView do
  use Scripture.Web, :view

  def formatted_datetime(datetime) do
    "#{formatted_integer datetime.day}.#{formatted_integer datetime.month}." <>
    "#{datetime.year}, " <>
    "#{formatted_integer datetime.hour}:#{formatted_integer datetime.minute}"
  end

  defp formatted_integer(number, digits \\ 2) do
    :io_lib.format "~#{digits}..0B", [number]
  end
end
