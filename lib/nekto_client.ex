defmodule NektoClient do
  @moduledoc """
  Provides helper functions
  """

  alias Socket.Web
  alias NektoClient.Http.Client

  @doc """
  Establishes WebSocket connection with custom host and args
  """
  @spec connect!(String.t, Keyword.t) :: Socket.Web.t | no_return
  def connect!(host, args) do
    Web.connect! host, args
  end

  @doc """
  Establishes WebSocket connection
  """
  @spec connect! :: Socket.Web.t | no_return
  def connect! do
    connect!(config_ws_host(), path: config_ws_path())
  end

  @doc """
  Closes WebSocket connection
  """
  @spec disconnect(Socket.Web.t) :: :ok | {:error, Socket.Web.error}
  def disconnect(socket) do
    Web.close(socket)
  end

  @doc """
  Requests new chat_token by http
  """
  @spec chat_token! :: String.t
  def chat_token! do
    Client.chat_token! config_host()
  end

  defp config_host do
    Application.get_env(:nekto_client, :host)
  end

  defp config_ws_host do
    Application.get_env(:nekto_client, :ws_host)
  end

  defp config_ws_path do
    Application.get_env(:nekto_client, :ws_path)
  end
end
