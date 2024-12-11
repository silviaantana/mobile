import 'package:absensi/page/absen/absen_page.dart';
import 'package:absensi/page/history/history_page.dart';
import 'package:absensi/page/leave/leave_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  final String role; // Menambahkan parameter untuk menerima role

  const MainPage({super.key, required this.role});

  Future<void> _logout(BuildContext context) async {
    // Konfirmasi sebelum logout
    final shouldLogout = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Hapus status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Logout dari Firebase
      await FirebaseAuth.instance.signOut();

      // Arahkan ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Center(
          child: Text(
            "Halaman Utama - $role", // Menampilkan role di judul halaman
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false, // Hilangkan ikon back
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Menampilkan menu sesuai dengan role
                  if (role == 'Mahasiswa') ...[
                    // Menu untuk Mahasiswa
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AbsenPage(),
                            ),
                          );
                        },
                        child: const Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/ic_absen.png'),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Absen Kehadiran",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeavePage(),
                            ),
                          );
                        },
                        child: const Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/ic_leave.png'),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Izin",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (role == 'Dosen') ...[
                    // Menu untuk Dosen
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPage(),
                            ),
                          );
                        },
                        child: const Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/ic_history.png'),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Riwayat Absensi",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              tooltip: "Logout",
              onPressed: () => _logout(context),
              child: const Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
