import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'page/login.dart';
import 'page/choose_role_page.dart'; // Import halaman ChooseRolePage
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cek status login
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const Login(),
        '/chooseRole': (context) => const ChooseRolePage(), // Tambahkan route ke halaman choose role
      },
      home: isLoggedIn
          ? const ChooseRolePage() // Langsung ke halaman pemilihan role setelah login
          : const Login(), // Jika belum login, tampilkan halaman login
    );
  }
}
