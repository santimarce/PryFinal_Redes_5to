// pages/login/login_page.dart

import 'package:flutter/material.dart';
//import 'package:page2/dashboard/dashboard.dart';
import 'package:page2/integracionbe/stream.dart';
import 'package:page2/login/login_auth.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  final String? ipmaquina;
  const LoginPage({super.key, this.ipmaquina});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final String ipmaquina;

  @override
  void initState() {
    super.initState();
    ipmaquina = widget.ipmaquina!;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/logo.jpeg',
                height: 120.0,
                width: 120.0,
              ), // Ajusta el tamaño según tus necesidades
              const SizedBox(height: 30.0),
              Text(
                'INICIA SESIÓN EN TU CUENTA \n CONEXION A: \t $ipmaquina',
                style: TextStyle(
                  fontSize: 24.0, // Tamaño de fuente más grande
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'USUARIO O CORREO',
                  prefixIcon: const Icon(Icons.person), // Ícono de persona
                  fillColor: Colors.grey[200], // Fondo gris claro
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[800]!), // Bordes gris oscuro
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un usuario o correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'CONTRASEÑA',
                  prefixIcon: const Icon(Icons.password), // Ícono de persona
                  fillColor: Colors.grey[200], // Fondo gris claro
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[800]!), // Bordes gris oscuro
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Access provider with listen: false
                    final ipText = ipmaquina;
                    final loginProvider =
                        Provider.of<LoginProvider>(context, listen: false);
                    loginProvider.login(
                        _emailController.text, _passwordController.text);

                    // Navigate to SuccessWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RemoteControlPage()),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.black), // Fondo negro
                  foregroundColor:
                      WidgetStateProperty.all(Colors.white), // Letras blancas
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Contorno cuadrado
                  )),
                  elevation: WidgetStateProperty.all(4.0), // Sombreado
                  overlayColor: WidgetStateProperty.all(
                      Colors.grey[800]), // Color de superposición
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15)), // Aumentar padding
                  minimumSize: WidgetStateProperty.all(const Size(160, 60)),
                ),
                child: const Text('INGRESAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}