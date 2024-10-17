import 'package:flutter/material.dart';
import 'views/pages/login_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramble',
      home: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: const LogInWidget()
      ),
    );
  }
}
