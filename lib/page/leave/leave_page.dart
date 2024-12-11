import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final controllerName = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  String dropValueCategories = "Pilih:";
  String? selectedMataKuliah;
  final categoriesList = ["Pilih:", "Izin", "Sakit"];
  final mataKuliahList = ["Pilih Mata Kuliah:", "Matematika", "Pemrograman Mobile", "Basis Data", "Jaringan Komputer"];
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absensi');
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    fromController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    toController.text = "Until";
  }

  Future<void> pickImage({required bool fromCamera, required String quality}) async {
    final picker = ImagePicker();
    final maxSize = quality == "HD" ? 1080 : 720;
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSize.toDouble(),
      maxHeight: maxSize.toDouble(),
    );

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = imageBytes;
      });
    }
  }

  Future<void> submitForm() async {
    if (controllerName.text.isEmpty || dropValueCategories == "Pilih:" || selectedMataKuliah == null || selectedMataKuliah == "Pilih Mata Kuliah:") {
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
      "category": dropValueCategories,
      "mata_kuliah": selectedMataKuliah,
      "from": fromController.text,
      "to": toController.text,
      "image": _selectedImageBytes != null
          ? base64Encode(_selectedImageBytes!)
          : null,
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await dataCollection.add(formData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil mengajukan izin!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        controllerName.clear();
        dropValueCategories = "Pilih:";
        selectedMataKuliah = "Pilih Mata Kuliah:";
        fromController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        toController.text = "Until";
        _selectedImageBytes = null;
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
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Menu Pengajuan Izin"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controllerName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nama Anda",
                ),
              ),
              const SizedBox(height: 16),
              const Text("Upload Gambar (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    onPressed: () => pickImage(fromCamera: true, quality: "HD"),
                    child: const Text("Kamera (HD)"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    onPressed: () => pickImage(fromCamera: false, quality: "Medium"),
                    child: const Text("Galeri (Medium)"),
                  ),
                ],
              ),
              if (_selectedImageBytes != null)
                Image.memory(_selectedImageBytes!, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: dropValueCategories,
                items: categoriesList.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => dropValueCategories = value!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMataKuliah,
                items: mataKuliahList.map((mataKuliah) {
                  return DropdownMenuItem(value: mataKuliah, child: Text(mataKuliah));
                }).toList(),
                onChanged: (value) => setState(() => selectedMataKuliah = value),
                decoration: const InputDecoration(labelText: "Mata Kuliah", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: fromController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "From",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: toController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "To",
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            toController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Ajukan Izin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
