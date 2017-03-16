defmodule NektoClientSpec do
  use ESpec

  alias Socket.Web

  let :socket, do: "socket"

  describe ".connect!/1" do
    let :host, do: "chat.nekto.me"

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
end
