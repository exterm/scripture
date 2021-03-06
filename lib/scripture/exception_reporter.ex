defmodule Scripture.ExceptionReporter do
  def rollbar_standard_metadata(conn) do
    headers_map = Map.new(conn.req_headers)
                  |> Map.delete("x-forwarded-for")
    %{
      framework: "phoenix " <> phoenix_version(),
      request: %{
        url: build_url(conn, headers_map),
        method: conn.method,
        headers: headers_map,
        query_string: conn.query_string
      }
      # person: %{
      #   // Required: id
      #   // A string up to 40 characters identifying this user in your system.
      #   id: "12345",

      #   // Optional: username
      #   // A string up to 255 characters
      #   username: "brianr",

      #   // Optional: email
      #   // A string up to 255 characters
      #   email: "brian@rollbar.com"
      # }
    }
  end

  defp build_url(conn, headers_map) do
    query_string = if String.length(conn.query_string) > 0, do: "?#{conn.query_string}"
    port_string  = if conn.port, do: ":#{conn.port}"

    host_string  = if(headers_map["x-forwarded-host"],
                      do: headers_map["x-forwarded-host"],
                      else: conn.host <> port_string)


    "#{conn.scheme}://#{host_string}#{conn.request_path}#{query_string}"
  end

  defp phoenix_version do
    loaded_applications = :application.loaded_applications()
    phoenix_tuple = List.keyfind(loaded_applications, :phoenix, 0)
    to_string(elem(phoenix_tuple, 2))
  end
end
