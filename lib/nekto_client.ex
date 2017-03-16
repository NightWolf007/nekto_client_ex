defmodule NektoClient do
  @moduledoc """
  Provides helper functions
  """

  alias Socket.Web

  @doc """
  Establishes WebSocket connection with host
  """
  @spec connect!(String.t) :: Socket.Web.t
  def connect!(host) do
    Web.connect! host
  end

  @doc """
  Establishes WebSocket connection with host with args
  """
  @spec connect!(String.t, Keyword.t) :: Socket.Web.t
  def connect!(host, args) do
    Web.connect! host, args
  end
end
