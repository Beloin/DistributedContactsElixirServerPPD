import socket


with socket.create_connection(("localhost", 9001)) as conn:
    conn.send("bye".encode())
    conn.recv(1)
    print("Disconnected from remote server")
