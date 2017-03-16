defmodule NektoClient.Http.Cookies do
  @moduledoc """
  Provides functions for parsing cookies
  """

  @doc """
  Parses cookies from Set-Cookie header to list of tuples

  ## Examples

      iex> cookies = "chat_token=974b16d4-dea8-11e6-8195-a4b2db396c9f; " <>
      ...>           "expires=Mon, 18-Jan-2027 00:37:15 GMT; " <>
      ...>           "path=/; " <>
      ...>           "__cfduid=de908cceddbf8993431084216fef88b271484872635; " <>
      ...>           "expires=Sat, 20-Jan-18 00:37:15 GMT; " <>
      ...>           "path=/; " <>
      ...>           "domain=.nekto.me; " <>
      ...>           "HttpOnly"
      iex> NektoClient.Http.Cookies.parse(cookies)
      [{"chat_token", "974b16d4-dea8-11e6-8195-a4b2db396c9f"},
       {"expires", "Mon, 18-Jan-2027 00:37:15 GMT"}, {"path", "/"},
       {"__cfduid", "de908cceddbf8993431084216fef88b271484872635"},
       {"expires", "Sat, 20-Jan-18 00:37:15 GMT"}, {"path", "/"},
       {"domain", ".nekto.me"}, {"HttpOnly"}]
  """
  @spec parse(String.t) :: list({String.t, String.t})
  def parse(cookies) do
    cookies
    |> String.split("; ")
    |> Enum.map(fn(x) -> x |> String.split("=") |> List.to_tuple end)
  end
end
