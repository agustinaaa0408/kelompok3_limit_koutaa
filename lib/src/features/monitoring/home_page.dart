import 'package:flutter/material.dart';

// 🔥 VARIABLE GLOBAL
String namaUser = "";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    StatistikPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////
/// ================= HOME =================
////////////////////////////////////////////////////
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalKuota = 10;
    double sisaKuota = 4;
    double persen = sisaKuota / totalKuota;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('KUOTA MONITOR'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 NAMA USER MUNCUL DI SINI
            Text(
              namaUser.isEmpty
                  ? "Halo, Selamat Datang!"
                  : "Halo, $namaUser 👋",
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue.shade800],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi, color: Colors.white, size: 40),
                  SizedBox(width: 10),
                  Text("Terhubung",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text("Penggunaan Kuota",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(value: persen),
                  const SizedBox(height: 10),
                  Text("${sisaKuota.toInt()} GB Sisa"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////
/// ================= STATISTIK =================
////////////////////////////////////////////////////
class StatistikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(child: Text("Halaman Statistik")),
    );
  }
}

////////////////////////////////////////////////////
/// ================= SETTING =================
////////////////////////////////////////////////////
class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _namaController = TextEditingController();

  void simpanNama() {
    setState(() {
      namaUser = _namaController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Nama disimpan: $namaUser"),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Pengguna",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Hai, Assalamualaikum",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpanNama,
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}