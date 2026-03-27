# 📡 Projeto Nó Sensor 
Este projeto demonstra a comunicação via **Sockets TCP/IP** entre um aplicativo Android (Nó Sensor) e um servidor Python.

## 🛠️ Como Funciona?
1. O **App Android** coleta o nível da bateria e a localização (GPS).
2. O **Servidor Python** recebe esses dados pela rede Wi-Fi e os salva em um arquivo de log.

## 💻 1. Rodar o Servidor 
No terminal, execute:
   python servidor_sensor.py

## 📱 2. Como Executar o App
O aplicativo pode ser executado pelo emulador (via comando flutter run) ou instalado diretamente no celular físico através do arquivo APK.
Com o servidor Python já rodando, abra o app no celular ou emulador e digite o Endereço IP do seu computador e a Porta (8080) nos campos indicados. 
Clique em "ENVIAR STATUS AGORA" para capturar os dados de bateria e GPS e transmiti-los ao servidor, conforme mostrado nas imagens abaixo:

![photo_5060185852763376542_y](https://github.com/user-attachments/assets/d9e94d94-cab1-4e58-bf63-014e52d6abcb)

![photo_5060185852763376542_y](https://github.com/user-attachments/assets/86773241-2709-46ec-a2f9-34fa7e62388c)

