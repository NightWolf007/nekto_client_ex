defmodule NektoClient.WebSocket.Client do
  @moduledoc """
  Nekto.me websocket wrapper
  Provides functions for communication with nekto.me websocket
  """

  alias Socket.Web

  @doc """
  Establishes connection with host
  """
  def connect!(host) do
    Web.connect! host
  end

  @doc """
  Establishes connection with host with args
  args - Socket.Web.connect method args
  """
  def connect!(host, args) do
    Web.connect! host, args
  end

  @doc """
  Sends json message to the server
  action - action type
  message - is hash
  """
  def send!(socket, action, message \\ %{}) do
    Web.send!(socket,
      {
        :text,
        message
        |> Map.merge(%{action: action})
        |> Poison.encode!
      }
    )
  end

  @doc """
  Receives single message from the server and parses it
  """
  def recv!(socket) do
    case Web.recv!(socket) do
      {:text, data} ->
        {:json, Poison.decode!(data)}
      data ->
        data
    end
  end

  @doc """
  Sends COUNT_ONLINE_USERS action to the server
  """
  def count_online_users!(socket) do
    socket |> send!("COUNT_ONLINE_USERS")
  end

  @doc """
  Sends AUTH action with user_token to the server
  """
  def auth!(socket, user_token) do
    socket |> send!("AUTH", %{user_token: user_token})
  end

  @doc """
  Sends SEARCH_COMPANY action with serach params to the server
  """
  def search_company!(socket, params) do
    socket |> send!("SEARCH_COMPANY", params)
  end

  @doc """
  Sends TYPING_A_MESSAGE action with typing status to the server
  """
  def typing_message!(socket, dialog_id, typing) do
    socket
    |> send!("TYPING_A_MESSAGE", %{dialog_id: dialog_id, typing: typing})
  end

  @doc """
  Sends CHAT_MESSAGE action to the server
  """
  def chat_message!(socket, dialog_id, request_id, text) do
    socket
    |> send!("CHAT_MESSAGE",
             %{dialog_id: dialog_id, request_id: request_id, text: text})
  end

  @doc """
  Sends CHAT_MESSAGE_READ action with list of message_ids to the server
  """
  def chat_message_read!(socket, dialog_id, message_ids) do
    socket
    |> send!("CHAT_MESSAGE_READ",
             %{dialog_id: dialog_id, message_ids: message_ids})
  end

  @doc """
  Sends LEAVE_DIALOG action to the server
  """
  def leave_dialog!(socket, dialog_id) do
    socket |> send!("LEAVE_DIALOG", %{dialog_id: dialog_id})
  end

  @doc """
  Sends OUT_SEARCH_COMPANY action to the server
  """
  def out_search_company!(socket) do
    socket |> send!("OUT_SEARCH_COMPANY")
  end
end
