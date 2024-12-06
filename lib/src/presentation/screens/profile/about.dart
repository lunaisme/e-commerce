import 'package:flutter/material.dart';

class AboutScreenPage extends StatelessWidget {
  // Constant values for identity and feedback
  final String name = "Habib Maulana Akbar";
  final String nim = "124220022";
  final String programStudy = "Sistem Informasi";
  final String impression =
      "Mata kuliah Pemrograman Aplikasi Mobile memberikan pengalaman yang sangat berharga. Saya belajar tentang dasar-dasar pengembangan aplikasi mobile, mulai dari konsep UI/UX hingga implementasi fungsionalitas menggunakan Flutter. Materi yang diajarkan sangat relevan dan aplikatif, memungkinkan saya untuk mengembangkan keterampilan yang berguna di dunia kerja.";
  final String message =
      "Saya ingin mengucapkan terima kasih kepada pengajar yang telah membimbing kami dengan sabar dan memberikan banyak informasi yang berguna. Terima kasih juga kepada teman-teman sekelas yang selalu mendukung dan berbagi pengetahuan. Mari kita terus belajar dan berkembang bersama!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('About Saya'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: SingleChildScrollView(
        // Menambahkan SingleChildScrollView
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identitas Diri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoTile('Nama', name),
            const Divider(thickness: 1, color: Colors.grey),
            _buildInfoTile('NIM', nim),
            const Divider(thickness: 1, color: Colors.grey),
            _buildInfoTile('Program Studi', programStudy),
            const SizedBox(height: 20),
            const Text(
              'Kesan dan Pesan Mata Kuliah Pemrograman Aplikasi Mobile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Kesan: $impression',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Pesan: $message',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
