defmodule NektoClient.WebSocket.Receiver do
  @moduledoc """
  Module for receiving messages from nekto.me websocket
  """

  alias Socket.Web
  alias NektoClient.Model.User
  alias NektoClient.Model.Dialog
  alias NektoClient.Model.Message

  @typedoc """
  Message from nekto.me WebSocket
  """
  @type message :: {atom, Map.t}

  @doc """
  Returns next message
  """
  @spec next(Socket.Web.t) :: {:ok, message} | {:ping, binary} |
                              {:error, Socket.Web.packet()}
  def next(socket) do
    case Web.recv!(socket)do
      {:text, data} ->
        {:ok, data |> Poison.decode! |> handle_response}
      {:ping, data} ->
        {:ping, data}
      data ->
        {:error, data}
    end
  end

  @doc """
  Starts thread which listens messages and sends them to gen_event
  """
  @spec listen(Socket.Web.t, GenEvent.t) :: none
  def listen(socket, gen_event) do
    listen_loop(socket, gen_event)
  end

  defp listen_loop(socket, gen_event) do
    case next(socket) do
      {:ok, data} -> GenEvent.notify(gen_event, data)
      {:ping, _} -> Web.send!(socket, {:pong, ""})
      _ -> nil
    end
    listen_loop(socket, gen_event)
  end

  defp handle_response(%{"notice" => "success_auth", "message" => message}) do
    %{"user" => %{"id" => id}} = message
    {:success_auth, User.new(id)}
  end

  defp handle_response(%{"notice" => "open_dialog", "message" => message}) do
    %{"id" => id, "uids" => uids} = message
    {:open_dialog, Dialog.new(id, uids)}
  end

  defp handle_response(%{"notice" => "chat_new_message",
                         "message" => message}) do
    %{"message_id" => id, "dialog_id" => dialog_id,
      "user" => %{"id" => uid}, "text" => text} = message
    {:chat_new_message, Message.new(id, dialog_id, uid, text)}
  end

  defp handle_response(%{"notice" => notice, "message" => message}) do
    {String.to_atom(notice), message}
  end

  defp handle_response(%{"notice" => notice}) do
    {String.to_atom(notice), %{}}
  end
end
