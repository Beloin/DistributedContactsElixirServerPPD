import socket


with socket.create_connection(("localhost", 9000)) as conn:
    conn.send("bye".encode())
    conn.recv(1)
    print("Disconnected from remote server")
