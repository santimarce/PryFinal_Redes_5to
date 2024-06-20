import 'package:flutter/material.dart';
import 'package:page2/index/index.dart';
import 'package:provider/provider.dart';

import 'login/login_auth.dart';
//import 'login/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider<LoginProvider>(
      create: (_) => LoginProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inicio',
      home: IndexPage(),
    );
  }
}
