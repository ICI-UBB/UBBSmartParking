import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estacionamiento App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(
          title: 'Estacionamiento Campus F.M Laboratorios Centrales UBB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int totalSpaces = 7;
  Map<int, dynamic> spacesData = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchSpaces();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _fetchSpaces());
  }

  Future<void> _fetchSpaces() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/get_spaces'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['espacios'];
        setState(() {
          spacesData = {for (var d in data) d['espacioID']: d};
        });
      } else {
        print("Error al obtener espacios: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectar con la API: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    int availableSpaces =
        spacesData.values.where((space) => space['estado'] == 'Libre').length;

    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.title))),
      body: Column(
        children: [
          _buildSpaceAvailabilityDisplay(availableSpaces),
          _buildParkingSpaceDisplay(),
          ElevatedButton(
            onPressed: _fetchSpaces,
            child: const Text('Actualizar estado de estacionamientos'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceAvailabilityDisplay(int availableSpaces) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Espacios disponibles: $availableSpaces / $totalSpaces',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hora Actual:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _getCurrentTime(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSpaceDisplay() {
    return Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: Colors.blueAccent,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('images/estacionamiento.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _buildParkingSpaces(),
          ),
        ),
      ),
    );
  }

  Widget _buildParkingSpaces() {
    List<Widget> widgets = [];
    for (var i = 1; i <= totalSpaces; i++) {
      widgets.add(_buildParkingSpaceWidget(i));
    }
    return Stack(children: widgets);
  }

  Widget _buildParkingSpaceWidget(int spaceId) {
    String status = spacesData[spaceId]?['estado'] ?? 'Desconocido';
    double top = (spaceId <= 3) ? 150.0 : 383.0;
    double left = (spaceId <= 3)
        ? 42.0 + (spaceId - 1) * 52.0
        : 2.0 + (spaceId - 4) * 52.0;

    return Positioned(
      top: top,
      left: left,
      child: ParkingSpaceWidget(
        spaceId: spaceId,
        status: status,
        width: 50,
        height: 100,
      ),
    );
  }
}

class ParkingSpaceWidget extends StatelessWidget {
  final int spaceId;
  final String status;
  final double width;
  final double height;

  const ParkingSpaceWidget({
    Key? key,
    required this.spaceId,
    required this.status,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = status == 'Libre' ? Colors.green : Colors.red;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          'Espacio $spaceId',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
