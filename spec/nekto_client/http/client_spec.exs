defmodule NektoClient.Http.ClientSpec do
  use ESpec

  alias HTTPoison.Response

  describe ".chat_token!/1" do
    let :bypass, do: Bypass.open
    let :path, do: "/chat"
    let :method, do: "HEAD"
    let :chat_token, do: "d13ca8fa-df36-11e6-8195-a4b1db396c9f"
    let :host, do: "https://nekto.me"
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
      allow HTTPoison |> to(
        accept :head!,
        fn(url) ->
          expect url |> to(eq host() <> path())
          %Response{body: body(), headers: headers(), status_code: status()}
        end
      )
    end

    it "returns chat token" do
      expect described_module().chat_token!(host())
      |> to(eq chat_token())
    end
  end
end
