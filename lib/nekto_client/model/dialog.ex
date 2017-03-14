defmodule NektoClient.Model.Dialog do
  @moduledoc """
  Dialog model
  """

  defstruct id: nil, uids: []

  @doc """
  Creates new dialog struct

  ## Examples

      iex> NektoClient.Model.Dialog.new(5, [1,2])
      %NektoClient.Model.Dialog{id: 5, uids: [1,2]}
  """
  def new(id, uids) do
    %NektoClient.Model.Dialog{id: id, uids: uids}
  end
end
