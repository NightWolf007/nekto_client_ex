defmodule NektoClient.WebSocket.ClientSpec do
  use ESpec

  alias Socket.Web

  let :host, do: "chat.nekto.me"
  let :path, do: "/websocket"
  let :socket, do: "socket"

  describe ".connect!/1" do
    it "connects to host" do
      allow Web |> to(accept :connect!,
        fn(host) -> expect host |> to(eq host()) end
      )
      described_module().connect!(host())
    end

    it "returns socket" do
      allow Web |> to(accept :connect!, fn(_) -> socket() end)
      expect described_module().connect!(host()) |> to(eq socket())
    end
  end

  describe ".connect!/2" do
    it "connects to host with args" do
      allow Web |> to(accept :connect!,
        fn(host, args) ->
          expect host |> to(eq host())
          expect args |> to(eq [path: path()])
        end
      )
      described_module().connect!(host(), path: path())
    end

    it "returns socket" do
      allow Web |> to(accept :connect!, fn(_, _) -> socket() end)
      expect described_module().connect!(host(), path: path())
      |> to(eq socket())
    end
  end

  describe ".send!/3" do
    let :action, do: "ACTION"
    let :message, do: %{message: "message"}
    let :encoded_message do
      Poison.encode!(%{action: action(), message: "message"})
    end

    it "sends message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().send!(socket(), action(), message())
    end
  end

  describe ".recv!/1" do
    let :message, do: %{"message" => "message"}
    let :encoded_message do
      Poison.encode!(message())
    end

    context "when it receives text message" do
      let :type, do: :text

      it "receives text message sand returns json message" do
        allow Web |> to(accept :recv!,
          fn(socket) ->
            expect socket |> to(eq socket())
            {type(), encoded_message()}
          end
        )
        expect described_module().recv!(socket()) |> to(eq {:json, message()})
      end
    end

    context "when it receives other message" do
      let :type, do: :ping

      it "receives text message sand returns json message" do
        allow Web |> to(accept :recv!,
          fn(socket) ->
            expect socket |> to(eq socket())
            {type(), encoded_message()}
          end
        )
        expect described_module().recv!(socket())
        |> to(eq {:ping, encoded_message()})
      end
    end
  end

  describe ".count_online_users!/1" do
    let :action, do: "COUNT_ONLINE_USERS"
    let :encoded_message do
      Poison.encode!(%{action: action()})
    end

    it "sends count_online_users message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().count_online_users!(socket())
    end
  end

  describe ".auth!/2" do
    let :user_token, do: "user_token"

    let :action, do: "AUTH"
    let :encoded_message do
      Poison.encode!(%{action: action(), user_token: user_token()})
    end

    it "sends auth message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().auth!(socket(), user_token())
    end
  end

  describe ".search_company!/2" do
    let :params, do: %{param: "param"}

    let :action, do: "SEARCH_COMPANY"
    let :encoded_message do
      params() |> Map.merge(%{action: action()}) |> Poison.encode!
    end

    it "sends search_company message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().search_company!(socket(), params())
    end
  end

  describe ".typing_message!/3" do
    let :dialog_id, do: 123
    let :typing, do: true

    let :action, do: "TYPING_A_MESSAGE"
    let :encoded_message do
      %{action: action(), dialog_id: dialog_id(), typing: typing()}
      |> Poison.encode!
    end

    it "sends typing_message message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().typing_message!(socket(), dialog_id(), typing())
    end
  end

  describe ".chat_message!/4" do
    let :dialog_id, do: 123
    let :request_id, do: 456
    let :text, do: "text"

    let :action, do: "CHAT_MESSAGE"
    let :encoded_message do
      %{action: action(), dialog_id: dialog_id(),
        request_id: request_id(), text: text()}
      |> Poison.encode!
    end

    it "sends chat_message message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().chat_message!(socket(), dialog_id(),
                                       request_id(), text())
    end
  end

  describe ".chat_message_read!/3" do
    let :dialog_id, do: 123
    let :message_ids, do: [1, 2, 3]

    let :action, do: "CHAT_MESSAGE_READ"
    let :encoded_message do
      %{action: action(), dialog_id: dialog_id(), message_ids: message_ids()}
      |> Poison.encode!
    end

    it "sends chat_message_read message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().chat_message_read!(socket(), dialog_id(),
                                            message_ids())
    end
  end

  describe ".leave_dialog!/2" do
    let :dialog_id, do: 123

    let :action, do: "LEAVE_DIALOG"
    let :encoded_message do
      Poison.encode!(%{action: action(), dialog_id: dialog_id()})
    end

    it "sends leave_dialog message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().leave_dialog!(socket(), dialog_id())
    end
  end

  describe ".out_search_company!/1" do
    let :action, do: "OUT_SEARCH_COMPANY"
    let :encoded_message do
      Poison.encode!(%{action: action()})
    end

    it "sends out_search_company message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().out_search_company!(socket())
    end
  end
end
