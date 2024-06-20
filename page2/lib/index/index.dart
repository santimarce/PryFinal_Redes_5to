import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _ipController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final ipText = _ipController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    print('Attempting login with IP: $ipText, Username: $username, Password: $password');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.103:8000/api/ssh/execute'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'host': ipText,
          'username': username,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Conectado') {
          print('Connection successful');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(ipmaquina: ipText),
            ),
          );
        } else {
          _showErrorDialog('SSH login failed.');
          print('Error: SSH login failed.');
        }
      } else {
        _showErrorDialog('Failed to connect to the server.');
        print('Error: Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/yavirac_logo.jpg',
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'BIENVENIDO A TU ACCESO REMOTO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.router,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'OFF POINT',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'IP DE SU MAQUINA',
                  prefixIcon: Icon(Icons.computer),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario SSH',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña SSH',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                onPressed: _login,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 10),
              const Text(
                'BY YAVIRAC',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
