import 'package:flutter/material.dart';
import 'package:squirrel_app/features/auth/presentation/pages/signup_screen.dart';
import 'dependency_injection.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squirrel',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

