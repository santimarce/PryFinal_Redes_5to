import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteControlPage extends StatefulWidget {
  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  final TextEditingController _keyController = TextEditingController();
  final String _serverUrl =
      'http://192.168.1.102:5000'; // Replace with your server URL
  String _key = '';
  bool _connected = false;
  Uint8List? _imageBytes;

  void _connect() async {
    final response = await http.post(
      Uri.parse('$_serverUrl/new_session'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'_key': _keyController.text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _key = _keyController.text;
        _connected = true;
      });
    } else {
      print('Failed to connect to the server');
    }
  }

  void _sendEvent(String eventType, Map<String, dynamic> eventDetails) async {
    final response = await http.post(
      Uri.parse('$_serverUrl/event_post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'_key': _key, 'type': eventType, ...eventDetails}),
    );

    if (response.statusCode != 200) {
      print('Failed to send event');
    }
  }

  void _getImage() async {
    final response = await http.post(
      Uri.parse('$_serverUrl/rd'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        '_key': _key,
        'filename': 'screenshot.png', // Adjust filename as needed
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _imageBytes = response.bodyBytes;
      });
    } else {
      print('Failed to load image');
    }
  }

  Widget _buildKeyButton(String label) {
    return ElevatedButton(
      onPressed: () => _sendEvent('keydown', {
        'key': label,
        'shiftKey': false,
        'ctrlKey': false,
        'altKey': false,
      }),
      child: Text(label),
    );
  }

  Widget _buildSpecialKeyButton(String label, String key) {
    return ElevatedButton(
      onPressed: () => _sendEvent('keydown', {
        'key': key,
        'shiftKey': false,
        'ctrlKey': false,
        'altKey': false,
      }),
      child: Text(label),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _sendEvent('mousemove', {
      'dx': details.delta.dx,
      'dy': details.delta.dy,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Desktop Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _keyController,
              decoration: InputDecoration(labelText: 'Enter Access Key'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connect,
              child: Text('Connect'),
            ),
            if (_connected) ...[
              if (_imageBytes != null) Image.memory(_imageBytes!),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildKeyButton('a'),
                  _buildKeyButton('b'),
                  _buildKeyButton('c'),
                  _buildKeyButton('d'),
                  _buildKeyButton('e'),
                  _buildKeyButton('f'),
                  _buildKeyButton('g'),
                  _buildKeyButton('h'),
                  _buildKeyButton('i'),
                  _buildKeyButton('j'),
                  _buildKeyButton('k'),
                  _buildKeyButton('l'),
                  _buildKeyButton('m'),
                  _buildKeyButton('n'),
                  _buildKeyButton('o'),
                  _buildKeyButton('p'),
                  _buildKeyButton('q'),
                  _buildKeyButton('r'),
                  _buildKeyButton('s'),
                  _buildKeyButton('t'),
                  _buildKeyButton('u'),
                  _buildKeyButton('v'),
                  _buildKeyButton('w'),
                  _buildKeyButton('x'),
                  _buildKeyButton('y'),
                  _buildKeyButton('z'),
                  _buildKeyButton('1'),
                  _buildKeyButton('2'),
                  _buildKeyButton('3'),
                  _buildKeyButton('4'),
                  _buildKeyButton('5'),
                  _buildKeyButton('6'),
                  _buildKeyButton('7'),
                  _buildKeyButton('8'),
                  _buildKeyButton('9'),
                  _buildKeyButton('0'),
                  _buildKeyButton(' '), // Space key
                  _buildSpecialKeyButton('Enter', 'Enter'),
                  _buildSpecialKeyButton('Backspace', 'Backspace'),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  child: Container(
                    color: Colors.grey[300],
                    child: Center(child: Text('Touchpad Area')),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
