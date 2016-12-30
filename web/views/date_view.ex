defmodule Scripture.DateView do
  use Scripture.Web, :view

  def formatted_datetime(datetime) do
    "#{datetime.day}.#{datetime.month}.#{datetime.year}, #{datetime.hour}:#{datetime.minute}"
  end
end
