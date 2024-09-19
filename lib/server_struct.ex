defmodule ServerStruct do
  defstruct host: "localhost", port: 9000, last_online: DateTime.utc_now()
end
