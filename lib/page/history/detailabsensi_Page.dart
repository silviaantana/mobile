import 'package:flutter/material.dart';

class DetailAbsensiPage extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final String from;
  final String to;

  const DetailAbsensiPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Absensi'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $name', style: TextStyle(fontSize: 18)),
            Text('Keterangan: $category', style: TextStyle(fontSize: 18)),
            Text('Dari: $from', style: TextStyle(fontSize: 18)),
            Text('Sampai: $to', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
