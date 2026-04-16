import 'package:flutter/material.dart';


String namaUser = "";
double globalTotalKuota = 10;
double globalSisaKuota = 4;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        HomeContent(onRefresh: refresh),
        const StatistikPage(),
        SettingPage(onSave: refresh),
      ];

  void refresh() {
    setState(() {});
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}


class HomeContent extends StatefulWidget {
  final VoidCallback onRefresh;

  const HomeContent({super.key, required this.onRefresh});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double usedData = 0;

  @override
  void initState() {
    super.initState();
    getDataUsage();
  }

  Future<void> getDataUsage() async {
    // SIMULASI dulu (karena akses real cukup kompleks)
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      usedData = 2.5; // contoh 2.5 GB terpakai
      globalSisaKuota = globalTotalKuota - usedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    double persen = globalSisaKuota / globalTotalKuota;

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
                  Text("${globalSisaKuota.toInt()} GB Sisa"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(child: Text("Halaman Statistik 📊")),
    );
  }
}


class SettingPage extends StatefulWidget {
  final VoidCallback onSave;

  const SettingPage({super.key, required this.onSave});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();

  void simpanData() {
    setState(() {
      namaUser = _namaController.text;

      double inputKuota =
          double.tryParse(_kuotaController.text) ?? globalTotalKuota;

      globalTotalKuota = inputKuota;
      globalSisaKuota = inputKuota;
    });

    widget.onSave(); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Tersimpan! Nama: $namaUser | Kuota: ${globalTotalKuota.toInt()} GB"),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kuotaController.dispose();
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
                hintText: "Masukkan nama",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Limit Kuota (GB)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(
              controller: _kuotaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Contoh: 20",
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
                onPressed: simpanData,
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}