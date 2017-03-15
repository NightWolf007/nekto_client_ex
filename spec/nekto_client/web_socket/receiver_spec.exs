defmodule NektoClient.WebSocket.ReceiverSpec do
  use ESpec

  alias Socket.Web

  let :socket, do: "socket"

  describe ".next/1" do
    it "sends pong on ping" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:pong, ""})
        end
      )
      mock_recv(:ping, %{})
      described_module().next(socket())
      expect Web |> to(accepted :send!, [socket(), {:pong, ""}], count: 1)
    end
  end

  def mock_recv(type, message) do
    allow Web |> to(accept :recv!,
      fn(_) ->
        {type, Poison.encode!(message)}
      end
    )
  end
end
