defmodule NektoClient.WebSocket.ReceiverSpec do
  use ESpec

  alias Socket.Web
  alias NektoClient.Model.User
  alias NektoClient.Model.Dialog
  alias NektoClient.Model.Message

  let :socket, do: "socket"

  describe ".next/1" do
    context "when receives ping" do
      let :type, do: :ping
      let :message, do: %{}

      it "returns ping" do
        mock_recv(type(), message())
        expect described_module().next(socket()) |> to(eq {type(), "{}"})
      end
    end

    context "when receives text" do
      let :type, do: :text

      context "and notice is success_auth" do
        let :user_id, do: 123
        let :message do
          %{
            "notice" => "success_auth",
            "message" => %{
              "user" => %{"id" => user_id()}
            }
          }
        end

        it "returns success_auth with user" do
          mock_recv(type(), message())
          expect described_module().next(socket())
          |> to(eq {:ok, {:success_auth, user_id() |> User.new}})
        end
      end

      context "and notice is open_dialog" do
        let :dialog_id, do: 123
        let :uids, do: [1, 2, 3]
        let :message do
          %{
            "notice" => "open_dialog",
            "message" => %{
              "id" => dialog_id(),
              "uids" => uids()
            }
          }
        end

        it "returns open_dialog with dialog" do
          mock_recv(type(), message())
          expect described_module().next(socket())
          |> to(eq {:ok, {:open_dialog, Dialog.new(dialog_id(), uids())}})
        end
      end

      context "and notice is chat_new_message" do
        let :message_id, do: 123
        let :dialog_id, do: 456
        let :user_id, do: 789
        let :text, do: "text"
        let :message do
          %{
            "notice" => "chat_new_message",
            "message" => %{
              "message_id" => message_id(),
              "dialog_id" => dialog_id(),
              "user" => %{"id" => user_id()},
              "text" => text()
            }
          }
        end
        let :result_message do
          Message.new(message_id(), dialog_id(), user_id(), text())
        end

        it "returns chat_new_message with message" do
          mock_recv(type(), message())
          expect described_module().next(socket())
          |> to(eq {:ok, {:chat_new_message, result_message()}})
        end
      end

      context "and notice is something other with message" do
        let :notice, do: "unknown"
        let :message do
          %{
            "notice" => notice(),
            "message" => %{"text" => "hello"}
          }
        end

        it "returns notice with message" do
          mock_recv(type(), message())
          expect described_module().next(socket())
          |> to(eq {:ok, {:unknown, Map.get(message(), "message")}})
        end
      end

      context "and notice is something other without message" do
        let :notice, do: "unknown"
        let :message do
          %{
            "notice" => notice()
          }
        end

        it "returns notice with empty message" do
          mock_recv(type(), message())
          expect described_module().next(socket())
          |> to(eq {:ok, {:unknown, %{}}})
        end
      end
    end
  end

  describe ".listen/2" do
    let :gen_event, do: "gen_event"

    context "when text message" do
      let :type, do: :text
      let :notice, do: "unknown"
      let :message, do: %{"notice" => notice()}

      before do
        mock_recv(type(), message())
        allow GenEvent |> to(accept :notify,
          fn("gen_event", {:unknown, %{}}) -> raise "mock" end
        )
      end

      it "notifies gen event" do
        expect fn -> described_module().listen(socket(), gen_event()) end
        |> to(raise_exception RuntimeError, "mock")
      end
    end

    context "when ping message" do
      let :type, do: :ping
      let :message, do: %{}

      before do
        mock_recv(type(), message())
        allow Web |> to(accept :send!,
          fn("socket", {:pong, ""}) -> raise "mock" end
        )
      end

      it "sends pong" do
        expect fn -> described_module().listen(socket(), gen_event()) end
        |> to(raise_exception RuntimeError, "mock")
      end
    end
  end

  def mock_recv(type, message) do
    allow Web |> to(accept :recv!, fn(_) -> {type, Poison.encode!(message)} end)
  end
end
