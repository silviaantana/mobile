import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final controllerName = TextEditingController();
  final controllerMataKuliah = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absensi');

  String? selectedMataKuliah;

  List<String> mataKuliahList = [
    "Pilih Mata Kuliah",
    "Pemrograman Mobile",
    "Basis Data",
    "Jaringan Komputer",
    "Sistem Informasi"
  ];

  Future<void> submitAbsensi() async {
    if (controllerName.text.isEmpty || selectedMataKuliah == null || selectedMataKuliah == "Pilih Mata Kuliah") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua field yang wajib diisi."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formData = {
      "name": controllerName.text,
      "category": "Hadir",
      "mata_kuliah": selectedMataKuliah,
      "from": DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "to": DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await dataCollection.add(formData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Absensi berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      controllerName.clear();
      setState(() {
        selectedMataKuliah = null; // Reset mata kuliah selection
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan data: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Menu Absensi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Hanya untuk Tampilkan Nama dan Pengaturan Lain
            const SizedBox(height: 20), // space for header removal
            // Input Nama
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                labelText: "Masukkan Nama Anda",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tanggal Absen (Auto)
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              ),
              decoration: const InputDecoration(
                labelText: "Tanggal Absen",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown Mata Kuliah
            DropdownButtonFormField<String>(
              value: selectedMataKuliah,
              onChanged: (value) {
                setState(() {
                  selectedMataKuliah = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Mata Kuliah",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                ),
              ),
              items: mataKuliahList.map((mataKuliah) {
                return DropdownMenuItem<String>(
                  value: mataKuliah,
                  child: Text(mataKuliah),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: submitAbsensi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 244, 223, 230),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Absen Sekarang",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 237, 152, 180),
                 ) // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
