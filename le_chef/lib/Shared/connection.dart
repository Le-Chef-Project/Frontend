import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    } as void Function(List<ConnectivityResult> event)?);
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result as ConnectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connection Check"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _isConnected
            ? const Text(
                "You are connected to the internet!",
                style: TextStyle(fontSize: 18, color: Colors.green),
              )
            : const Text(
                "No Internet Connection!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
      ),
    );
  }
}
