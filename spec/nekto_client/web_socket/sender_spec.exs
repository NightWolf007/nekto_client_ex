defmodule NektoClient.WebSocket.SenderSpec do
  use ESpec

  alias Socket.Web
  alias NektoClient.Model.SearchOptions

  let :socket, do: "socket"

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
    let :search_options, do: SearchOptions.new(%{my_sex: "M", wish_sex: "W"})

    let :action, do: "SEARCH_COMPANY"
    let :encoded_message do
      search_options()
      |> SearchOptions.serialize()
      |> Map.merge(%{action: action()})
      |> Poison.encode!
    end

    it "sends search_company message" do
      allow Web |> to(accept :send!,
        fn(socket, message) ->
          expect socket |> to(eq socket())
          expect message |> to(eq {:text, encoded_message()})
        end
      )
      described_module().search_company!(socket(), search_options())
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
