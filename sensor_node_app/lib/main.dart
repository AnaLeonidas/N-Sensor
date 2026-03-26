import 'dart:io';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SensorNodeApp(),
  ));
}

class SensorNodeApp extends StatefulWidget {
  const SensorNodeApp({super.key});

  @override
  State<SensorNodeApp> createState() => _SensorNodeAppState();
}

class _SensorNodeAppState extends State<SensorNodeApp> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portaController = TextEditingController();
  String _status = "Aguardando envio...";

  Future<void> enviarDados() async {
    setState(() => _status = "Obtendo dados...");

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      int nivelBat = await Battery().batteryLevel;
      Position pos = await Geolocator.getCurrentPosition();

      String mensagem = "Bateria: $nivelBat% | Lat: ${pos.latitude} | Long: ${pos.longitude}\n";

      String ip = _ipController.text;
      int porta = int.parse(_portaController.text);

      Socket socket = await Socket.connect(ip, porta, timeout: const Duration(seconds: 5));
      socket.write(mensagem);
      await socket.flush();
      await socket.close();

      setState(() => _status = "Enviado com sucesso!");
    } catch (e) {
      setState(() => _status = "Erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text("Nó Sensor", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.sensors, size: 50, color: Colors.indigo),
                    const SizedBox(height: 10),
                    const Text("Configuração", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    
                    TextField(
                      controller: _ipController,
                      decoration: const InputDecoration(
                        labelText: "IP do Servidor",
                        prefixIcon: Icon(Icons.computer),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _portaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Porta",
                        prefixIcon: Icon(Icons.settings_input_component),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: enviarDados,
              icon: const Icon(Icons.send),
              label: const Text("ENVIAR STATUS AGORA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _status.contains("sucesso") ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _status.contains("sucesso") ? Colors.green : Colors.blue),
              ),
              child: Row(
                children: [
                  Icon(
                    _status.contains("sucesso") ? Icons.check_circle : Icons.info,
                    color: _status.contains("sucesso") ? Colors.green[800] : Colors.blue[800],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _status,
                      style: TextStyle(
                        color: _status.contains("sucesso") ? Colors.green[900] : Colors.blue[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}