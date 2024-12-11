import 'package:flutter/material.dart';
import 'main_page.dart'; // Pastikan halaman MainPage sudah ada dan siap digunakan

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  _ChooseRolePageState createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validasi NIP: Harus 8 angka
  String? _validateNip(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIP tidak boleh kosong';
    } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return 'NIP harus terdiri dari 8 angka';
    }
    return null;
  }

  // Validasi Nama: Harus huruf saja
  String? _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf';
    }
    return null;
  }

  // Validasi NIM: Maksimal 8 karakter
  String? _validateNim(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    } else if (value.length > 8) {
      return 'NIM maksimal 8 karakter';
    }
    return null;
  }

  void _onDosenPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(role: 'Dosen')),
      );
    }
  }

  void _onMahasiswaPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(role: 'Mahasiswa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pilih Peran'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pilih Peran Anda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Ikon Dosen
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      // Tampilkan form input untuk Dosen
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Masukkan Data Dosen'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _nipController,
                                  decoration: const InputDecoration(
                                    labelText: 'NIP',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: _validateNip,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _namaController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: _validateNama,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_validateNip(_nipController.text) == null &&
                                      _validateNama(_namaController.text) == null) {
                                    Navigator.pop(context);
                                    _onDosenPressed();
                                  } else {
                                    setState(() {});
                                  }
                                },
                                child: const Text('Lanjutkan Dosen'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Text(
                    'Dosen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Ikon Mahasiswa
                  IconButton(
                    icon: const Icon(
                      Icons.school,
                      size: 100,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      // Tampilkan form input untuk Mahasiswa
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Masukkan Data Mahasiswa'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _nimController,
                                  decoration: const InputDecoration(
                                    labelText: 'NIM',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: _validateNim,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_validateNim(_nimController.text) == null) {
                                    Navigator.pop(context);
                                    _onMahasiswaPressed();
                                  } else {
                                    setState(() {});
                                  }
                                },
                                child: const Text('Lanjutkan Mahasiswa'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Text(
                    'Mahasiswa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
