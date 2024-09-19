defmodule DistributedServer do
  @moduledoc """
  Documentation for `DistributedServer`.
  """

  require Logger

  @doc """
  Hello world.

  ## Examples

      iex> DistributedServer.hello()
      :world

  """
  def hello do
    :world
  end

  def start(port) do
    spawn(fn ->
      case :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true]) do
        {:ok, socket} ->
          Logger.info("Listening on #{port}")
          accept_connnection(socket)

        {:error, reason} ->
          Logger.error("Could not listen on #{port}: #{reason}")
      end
    end)
  end

  def accept_connnection(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    spawn(fn ->
      {:ok, buffer_pid} = Buffer.create()
      Process.flag(:trap_exit, true)
      serve(client, buffer_pid)
    end)

    accept_connnection(socket)
    # loop_accept(socket)
  end

  def serve(socket, buffer_pid) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        buffer_pid = maybe_recreate_buffer(buffer_pid)
        Buffer.receive(buffer_pid, data)
        # TODO: Is this ok?
        serve(socket, buffer_pid)

      {:error, reson} ->
        Logger.info("Socket terminating: #{inspect(reson)}")
    end
  end

  defp maybe_recreate_buffer(original_pid) do
    receive do
      {:EXIT, ^original_pid, _reason} ->
        {:ok, new_buffer_pid} = Buffer.create()
        new_buffer_pid
    after
      # 10ms
      10 -> original_pid
    end
  end
end
