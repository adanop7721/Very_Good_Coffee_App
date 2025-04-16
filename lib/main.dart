import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/coffee_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CoffeeImageAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Very Good Coffee App',
      home: Scaffold(
        body: Center(child: Text('Hello Coffee')),
      ),
    );
  }
}