defmodule Scripture.HomepageController do
   use Scripture.Web, :controller
 
   def index(conn, _params) do
     render conn, "index.html"
   end
 end
