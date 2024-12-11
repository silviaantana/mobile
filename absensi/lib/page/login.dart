import 'package:absensi/page/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'choose_role_page.dart'; // Import halaman ChooseRolePage

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      // Login dengan Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Menyimpan status login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Redirect ke halaman ChooseRolePage setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseRolePage(), // Arahkan ke ChooseRolePage
        ),
      );
    } catch (e) {
      // Jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  // Fungsi untuk menangani registrasi akun baru
  Future<void> _signup() async {
    // Misalnya, ganti dengan halaman SignUp Anda
    // Di sini, Anda bisa membuat atau menggunakan halaman SignUp terpisah
    // Untuk saat ini, kita hanya menggunakan Navigator untuk berpindah halaman
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpPage(), // Pastikan Anda membuat halaman SignUpPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ATTANDANCE"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            const SizedBox(height: 16),
            // Tombol untuk pendaftaran akun baru (Sign Up)
            TextButton(
              onPressed: _signup,
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
