import socket
import datetime

def iniciar_servidor(ip='0.0.0.0', porta=8080):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        server_socket.bind((ip, porta))
        server_socket.listen(5)
        print(f"[*] Servidor aguardando conexões em {ip}:{porta}")
        while True:
            client_socket, addr = server_socket.accept()
            print(f"[*] Conexão recebida de {addr}")
            dados = client_socket.recv(1024).decode('utf-8')
            if dados:
                timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                log_msg = f"[{timestamp}] Origem: {addr} | Dados: {dados}"
                
                print(log_msg)
                with open("log_sensores.txt", "a") as f:
                    f.write(log_msg + "\n")
            
            client_socket.close()
            
    except Exception as e:
        print(f"[!] Erro no servidor: {e}")
    finally:
        server_socket.close()

if __name__ == "__main__":
    iniciar_servidor()