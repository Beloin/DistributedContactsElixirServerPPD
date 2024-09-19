defmodule DistributedServerTest do
  use ExUnit.Case
  doctest DistributedServer

  test "greets the world" do
    assert DistributedServer.hello() == :world
  end
end
