defmodule NektoClient.Model.Message do
  @moduledoc """
  Message model
  """

  defstruct [:id, :dialog_id, :uid, :text]

  @doc """
  Creates new message struct

  ## Examples

      iex> NektoClient.Model.Message.new(5, 10, 12345, "test message")
      %NektoClient.Model.Message{id: 5, dialog_id: 10, uid: 12345,
                                 text: "test message"}
  """
  def new(id, dialog_id, uid, text) do
    %NektoClient.Model.Message{
      id: id, dialog_id: dialog_id, uid: uid, text: text
    }
  end
end
