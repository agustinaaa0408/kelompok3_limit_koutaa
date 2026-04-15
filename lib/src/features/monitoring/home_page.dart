import 'package:flutter/material.dart';
import 'package:limit_kuota/src/features/monitoring/network_page.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const StatistikPage(),
    const SettingPage(),
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
/// ================= HOME CONTENT =================
////////////////////////////////////////////////////
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo, Selamat Datang!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

              const SizedBox(height: 30),

              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text("Cek Detail Jaringan"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Network()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////
/// ================= STATISTIK =================
////////////////////////////////////////////////////
class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Statistik Kuota"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Penggunaan Mingguan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            Container(
              height: 250,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 4,
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 5),
                        FlSpot(4, 3),
                        FlSpot(5, 4),
                        FlSpot(6, 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Ringkasan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  children: [
                    Text("Total Mingguan"),
                    SizedBox(height: 5),
                    Text("20 GB",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text("Rata-rata"),
                    SizedBox(height: 5),
                    Text("3 GB/hari",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////
/// ================= SETTING =================
////////////////////////////////////////////////////
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _kuotaController = TextEditingController();

  bool isNotificationOn = true;
  bool isDarkMode = false;

  @override
  void dispose() {
    _kuotaController.dispose();
    super.dispose();
  }

  void simpanSetting() {
    String kuota = _kuotaController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Setting disimpan! Limit: $kuota GB"),
      ),
    );
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
            const Text("Limit Kuota (GB)",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: _kuotaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan batas kuota",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SwitchListTile(
              title: const Text("Notifikasi Kuota"),
              value: isNotificationOn,
              onChanged: (value) {
                setState(() {
                  isNotificationOn = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpanSetting,
                child: const Text("Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}