import 'package:absensi/page/history/detailabsensi_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';  // Pastikan untuk mengimport DetailAbsensiPage

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absensi');

  String searchDate = ""; // Untuk menyimpan input tanggal pencarian

  Future<void> deleteAbsensi(String id) async {
    try {
      await dataCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Absensi berhasil dihapus!"),
        backgroundColor: Colors.green,
      ));
      setState(() {}); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal menghapus absensi."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // TextField untuk input pencarian tanggal
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Cari berdasarkan tanggal (DD/MM/YYYY)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchDate = value.trim(); // Simpan input pencarian
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: dataCollection
                  .orderBy('timestamp', descending: true) // Urutkan berdasarkan timestamp
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;

                  // Filter data berdasarkan tanggal pencarian
                  if (searchDate.isNotEmpty) {
                    data = data.where((doc) {
                      String fromDate = doc['from']; // Tanggal dari LeavePage
                      return fromDate.contains(searchDate);
                    }).toList();
                  }

                  return data.isNotEmpty
                      ? ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              margin: const EdgeInsets.all(10),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.pinkAccent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Center(
                                          child: Text(
                                        data[index]['name'][0].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14),
                                      ))),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Nama: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                data[index]['name'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Keterangan: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                data[index]['category'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Dari: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                data[index]['from'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Sampai: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                data[index]['to'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // Dialog konfirmasi penghapusan
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Hapus Absensi"),
                                            content: const Text(
                                                "Apakah Anda yakin ingin menghapus absensi ini?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteAbsensi(data[index].id);
                                                },
                                                child: const Text("Hapus"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    // Menambahkan navigasi ke DetailAbsensiPage
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Navigasi ke halaman DetailAbsensiPage
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailAbsensiPage(
                                              id: data[index].id, // Pass id document
                                              name: data[index]['name'],
                                              category: data[index]['category'],
                                              from: data[index]['from'],
                                              to: data[index]['to'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("Tidak ada data ditemukan!"),
                        );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
