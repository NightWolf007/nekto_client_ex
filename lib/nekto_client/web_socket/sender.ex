defmodule NektoClient.WebSocket.Sender do
  @moduledoc """
  Module for sending messages from nekto.me websocket
  """

  alias Socket.Web
  alias NektoClient.Model.SearchOptions

  @doc """
  Sends json message to the server
  action - action type
  message - is hash
  """
  @spec send!(Socket.Web.t, String.t, Map.t) :: :ok | no_return
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
  Sends COUNT_ONLINE_USERS action to the server
  """
  @spec count_online_users!(Socket.Web.t) :: :ok | no_return
  def count_online_users!(socket) do
    socket |> send!("COUNT_ONLINE_USERS")
  end

  @doc """
  Sends AUTH action with user_token to the server
  """
  @spec auth!(Socket.Web.t, String.t) :: :ok | no_return
  def auth!(socket, user_token) do
    socket |> send!("AUTH", %{user_token: user_token})
  end

  @doc """
  Sends SEARCH_COMPANY action with search_options to the server
  """
  @spec search_company!(Socket.Web.t,
                        NektoClient.Model.SearchOptions.t) :: :ok | no_return
  def search_company!(socket, search_options) do
    socket |> send!("SEARCH_COMPANY", SearchOptions.serialize(search_options))
  end

  @doc """
  Sends TYPING_A_MESSAGE action with typing status to the server
  """
  @spec typing_message!(Socket.Web.t, integer, boolean) :: :ok | no_return
  def typing_message!(socket, dialog_id, typing) do
    socket
    |> send!("TYPING_A_MESSAGE", %{dialog_id: dialog_id, typing: typing})
  end

  @doc """
  Sends CHAT_MESSAGE action to the server
  """
  @spec chat_message!(Socket.Web.t, integer,
                      integer, String.t) :: :ok | no_return
  def chat_message!(socket, dialog_id, request_id, text) do
    socket
    |> send!("CHAT_MESSAGE",
             %{dialog_id: dialog_id, request_id: request_id, text: text})
  end

  @doc """
  Sends CHAT_MESSAGE_READ action with list of message_ids to the server
  """
  @spec chat_message_read!(Socket.Web.t, integer,
                           list(integer)) :: :ok | no_return
  def chat_message_read!(socket, dialog_id, message_ids) do
    socket
    |> send!("CHAT_MESSAGE_READ",
             %{dialog_id: dialog_id, message_ids: message_ids})
  end

  @doc """
  Sends LEAVE_DIALOG action to the server
  """
  @spec leave_dialog!(Socket.Web.t, integer) :: :ok | no_return
  def leave_dialog!(socket, dialog_id) do
    socket |> send!("LEAVE_DIALOG", %{dialog_id: dialog_id})
  end

  @doc """
  Sends OUT_SEARCH_COMPANY action to the server
  """
  @spec out_search_company!(Socket.Web.t) :: :ok | no_return
  def out_search_company!(socket) do
    socket |> send!("OUT_SEARCH_COMPANY")
  end
end
