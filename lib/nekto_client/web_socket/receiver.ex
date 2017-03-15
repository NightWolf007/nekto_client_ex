defmodule NektoClient.WebSocket.Receiver do
  @moduledoc """
  Module for receiving messages from nekto.me websocket
  """

  alias Socket.Web
  alias NektoClient.WebSocket.Client
  alias NektoClient.Model.User
  alias NektoClient.Model.Dialog
  alias NektoClient.Model.Message

  @doc """
  Returns next message
  """
  def next(socket) do
    case Client.recv!(socket) do
      {:json, data} ->
        {:ok, handle_response(data)}
      {:ping, data} ->
        {:ping, data}
      data ->
        {:error, data}
    end
  end

  @doc """
  Starts thread which listens messages and sends them to gen_event
  """
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
