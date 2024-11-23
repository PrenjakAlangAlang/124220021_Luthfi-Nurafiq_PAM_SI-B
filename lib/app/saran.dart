import 'package:flutter/material.dart';
import 'package:quran/app/home.dart';
import 'package:quran/app/profile.dart';

class Saran extends StatefulWidget {
  const Saran({super.key});

  @override
  State<Saran> createState() => _SaranState();
}

class _SaranState extends State<Saran> {
  int _currentIndex = 1;

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        // Already on Saran page
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Kesan & Pesan',
            style: TextStyle(
              color: const Color(0xFF1DB954),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Kesan',
              'Mata kuliah Pemrograman Aplikasi Mobile memberikan pengalaman yang sangat berharga dalam pengembangan aplikasi mobile. Pembelajaran Framework Flutter dengan bahasa pemrograman Dart sangat menarik dan membantu dalam memahami konsep pengembangan aplikasi mobile modern. Materi yang diajarkan sangat relevan dengan kebutuhan industri saat ini.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Pesan',
              'Untuk pengembangan ke depan, sebaiknya ditambahkan lebih banyak pelajaran praktek di dalam kelas agar mahasiswa dapat lebih mudah memahami materi. Selain itu, akan sangat membantu jika ada sesi khusus untuk membahas best practices dalam pengembangan aplikasi mobile dan tips untuk memasuki industri pengembangan aplikasi mobile.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Harapan',
              'Semoga ilmu yang didapat dari mata kuliah ini dapat bermanfaat untuk pengembangan karir di bidang mobile development.',
            ),
            const SizedBox(height: 24),
            _buildQuoteCard(
              'Mobile development is not just about coding, it\'s about creating experiences that make people\'s lives better.',
              'Developer Quote',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF1DB954),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Saran'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      color: const Color(0xFF191414),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(String quote, String author) {
    return Card(
      color: const Color(0xFF176D35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              quote,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '- $author',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
