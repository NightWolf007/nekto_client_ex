defmodule NektoClientSpec do
  use ESpec

  alias Socket.Web
  alias HTTPoison.Response

  let :socket, do: "socket"

  describe ".connect!/0" do
    let :host, do: "chat.nekto.me"
    let :path, do: "/websocket"

    before do
      Application.put_env(:nekto_client, :ws_host, host())
      Application.put_env(:nekto_client, :ws_path, path())
    end

    it "connects to host with path" do
      allow Web |> to(accept :connect!,
        fn(host, path: path) ->
          expect host |> to(eq host())
          expect path |> to(eq path())
        end
      )
      described_module().connect!
    end

    it "returns socket" do
      allow Web |> to(accept :connect!, fn(_, _) -> socket() end)
      expect described_module().connect! |> to(eq socket())
    end
  end

  describe ".connect!/2" do
    let :host, do: "chat.nekto.me"
    let :path, do: "/websocket"

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

  describe "disconnect/1" do
    it "closes connection to socket" do
      allow Web |> to(accept :close,
        fn(socket) ->
          expect socket |> to(eq socket())
        end
      )
      described_module().disconnect(socket())
    end
  end

  describe ".chat_token!" do
    let :host, do: "nekto.me"

    let :bypass, do: Bypass.open
    let :path, do: "/chat"
    let :method, do: "HEAD"
    let :chat_token, do: "d13ca8fa-df36-11e6-8195-a4b1db396c9f"
    let :headers do
      [
        {"Content-Type", "text/html; charset=utf-8"},
        {"Set-Cookie", "__cfduid=dfb9f97c61d1cd817536988f688e12b0f14849; " <>
                       "expires=Sat, 20-Jan-18 17:35:21 GMT; " <>
                       "path=/; domain=.nekto.me; HttpOnly"},
        {"Set-Cookie", "chat_token=#{chat_token()}; " <>
                       "expires=Mon, 18-Jan-2027 17:35:21 GMT; path=/"}
      ]
    end
    let :status, do: 200
    let :body, do: ""

    before do
      Application.put_env(:nekto_client, :host, host())
      allow HTTPoison |> to(
        accept :head!,
        fn(url) ->
          expect url |> to(eq host() <> path())
          %Response{body: body(), headers: headers(), status_code: status()}
        end
      )
    end

    it "returns chat token" do
      expect described_module().chat_token!
      |> to(eq chat_token())
    end
  end
end
