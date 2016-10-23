defmodule Scripture.HomepageControllerTest do
   use Scripture.ConnCase
 
   test "GET /", %{conn: conn} do
     conn = get conn, "/"

     html_response(conn, 200)
     
     # TODO
     # assert html_response(conn, 200) =~ "Hier sind die neusten Artikel gelistet"
   end
 end
