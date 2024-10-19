import 'package:flutter/material.dart';
import 'controllers/user_controller.dart';
import 'views/pages/login_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramble',
      home: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LogInWidget(userController: UserController())
      ),
    );
  }
}
