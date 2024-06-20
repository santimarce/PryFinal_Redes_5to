import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class FileApp extends StatefulWidget {
  final String? ipmaquina;

  const FileApp({
    Key? key,
    this.ipmaquina,
  }) : super(key: key);

  @override
  _FileAppState createState() => _FileAppState();
}

class _FileAppState extends State<FileApp> {
  TextEditingController _fileController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late final String ipmaquina;

  @override
  void initState() {
    super.initState();
    ipmaquina = widget.ipmaquina!;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileController.text = result.files.single.path ?? '';
      });
    }
  }

  Future<void> _uploadFile() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (_fileController.text.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      File file = File(_fileController.text);

      String url = 'http://192.168.1.103:8000/api/receive-file'; // Cambiar a tu URL de Laravel
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['username'] = username; // Agregar username al request
      request.fields['password'] = password; // Agregar password al request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Archivo enviado correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error al enviar el archivo: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar el archivo: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un archivo y asegúrate de haber ingresado usuario y contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envío de archivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selecciona un archivo y envíalo al servidor',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _fileController,
                    decoration: InputDecoration(
                      labelText: 'Archivo seleccionado',
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Seleccionar Archivo'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadFile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Enviar'),
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
