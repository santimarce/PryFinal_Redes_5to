// pages/login/login_provider.dart

import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  // Getter para acceder al estado de autenticación
  bool get isLoggedIn => _isLoggedIn;

  // Método para iniciar sesión
  void login(String email, String password) async {
    // Implementar la lógica de autenticación aquí
    print(
        'Iniciando sesión con correo electrónico: $email y contraseña: $password');

    // Simulando una solicitud de autenticación al servidor (reemplazar con su implementación real)
    await Future.delayed(
        const Duration(seconds: 2)); // Simular tiempo de espera

    // En caso de éxito, actualizar el estado del provider
    if (true) {
      // condicionar el inicio de sesión se puede poner esa clave publica
      _isLoggedIn = true;
      notifyListeners(); // Notificar a los consumidores de cambios en el estado
      print('Inicio de sesión exitoso');
    } //else {
    // En caso de error, mostrar un mensaje de error
    //print('Error de inicio de sesión: Credenciales incorrectas');
    //}
  }
}
