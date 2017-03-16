defmodule NektoClient.Http.Headers do
  @moduledoc """
  Provides functions for parsing headers
  """

  @doc """
  Finds all occurrences of header in headers

  ## Examples

      iex> headers = [
      ...>   {"Date", "Fri, 20 Jan 2017 12:22:48 GMT"},
      ...>   {"Content-Type", "text/html; charset=utf-8"},
      ...>   {"Connection", "keep-alive"},
      ...>   {"Set-Cookie",
      ...>    "__cfduid=da165f62003f8ac3c7875bfb55c52769a1484914968; " <>
      ...>    "expires=Sat, 20-Jan-18 12:22:48 GMT; " <>
      ...>    "path=/; domain=.nekto.me; HttpOnly"},
      ...>   {"Expires", "Mon, 26 Jul 1997 05:00:00 GMT"},
      ...>   {"Cache-Control", "no-store, no-cache, must-revalidate"},
      ...>   {"Cache-Control", "post-check=0, pre-check=0"},
      ...>   {"Set-Cookie",
      ...>    "chat_token=27b54092-df0b-11e6-8195-a4badb396c9f; " <>
      ...>    "expires=Mon, 18-Jan-2027 12:22:48 GMT; path=/"},
      ...>   {"Server", "cloudflare-nginx"}]
      iex> NektoClient.Http.Headers.find(headers, "Set-Cookie")
      ["chat_token=27b54092-df0b-11e6-8195-a4badb396c9f; " <>
       "expires=Mon, 18-Jan-2027 12:22:48 GMT; path=/",
       "__cfduid=da165f62003f8ac3c7875bfb55c52769a1484914968; " <>
       "expires=Sat, 20-Jan-18 12:22:48 GMT; " <>
       "path=/; domain=.nekto.me; HttpOnly"]
  """
  @spec find(list({String.t, String.t}), String.t) :: list(String.t)
  def find(headers, header) do
    List.foldl(headers, [],
      fn(x, acc) ->
        case x do
          {^header, value} -> [value | acc]
          _ -> acc
        end
      end
    )
  end
end
