import 'package:assignment2/SignUpScreen.dart';
import 'package:assignment2/provider/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/provider/store_provider.dart';
import 'package:assignment2/WelcomePage.dart';

import 'SQLite/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.getDatabase();
  runApp(
    ChangeNotifierProvider<StoreProvider>(
      create: (_) => StoreProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: WelcomePage(), // Set the WelcomePage as the initial screen
    );
  }
}