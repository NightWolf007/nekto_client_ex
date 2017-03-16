defmodule NektoClient.Http.Client do
  @moduledoc """
  Provides functions for nekto.me HTTP API
  """

  alias NektoClient.Http.Headers
  alias NektoClient.Http.Cookies

  @doc """
  Gets headers from nekto chat and parses chat_token
  """
  @spec chat_token!(String.t) :: String.t
  def chat_token!(host) do
    HTTPoison.head!(chat_url(host)).headers
    |> Headers.find("Set-Cookie")
    |> Enum.join("; ")
    |> Cookies.parse
    |> List.keyfind("chat_token", 0)
    |> elem(1)
  end

  defp chat_url(host) do
    "#{host}/chat"
  end
end
