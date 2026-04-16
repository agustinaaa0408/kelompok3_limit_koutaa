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

  void refresh() {
    setState(() {});
  }

  List<Widget> get _pages => [
        HomeContent(onRefresh: refresh),
        const StatistikPage(),
        SettingPage(onSave: refresh),
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
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////
/// HOME CONTENT
////////////////////////////////////////////////////
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
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      usedData = 2.5;
      globalSisaKuota = globalTotalKuota - usedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    double terpakai = globalTotalKuota - globalSisaKuota;

    double progress =
        globalTotalKuota == 0 ? 0 : terpakai / globalTotalKuota;

    Color warnaProgress;
    if (progress < 0.5) {
      warnaProgress = Colors.green;
    } else if (progress < 0.8) {
      warnaProgress = Colors.orange;
    } else {
      warnaProgress = Colors.red;
    }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pemakaian Kuota",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 15),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(warnaProgress),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${terpakai.toStringAsFixed(1)} GB terpakai"),
                      Text("${globalSisaKuota.toStringAsFixed(1)} GB sisa"),
                    ],
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

////////////////////////////////////////////////////
/// STATISTIK
////////////////////////////////////////////////////
class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistik")),
      body: const Center(child: Text("Halaman Statistik")),
    );
  }
}

////////////////////////////////////////////////////
/// SETTING
////////////////////////////////////////////////////
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
      globalTotalKuota =
          double.tryParse(_kuotaController.text) ?? globalTotalKuota;
      globalSisaKuota = globalTotalKuota;
    });

    widget.onSave();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data tersimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _namaController),
            TextField(controller: _kuotaController),
            ElevatedButton(onPressed: simpanData, child: const Text("Simpan"))
          ],
        ),
      ),
    );
  }
}