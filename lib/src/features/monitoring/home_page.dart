import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:limit_kuota/src/features/monitoring/network_page.dart';

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
    SettingPage(onSave: refresh),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  double usedData = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  final List<double> dataBulanan = List.generate(
    30,
    (i) => (i % 5 + 1).toDouble(),
  );

  double get total => dataBulanan.reduce((a, b) => a + b);
  double get rataRata => total / dataBulanan.length;

  @override
  void initState() {
    super.initState();
    getDataUsage();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  Future<void> getDataUsage() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      usedData = 2.5;
      globalSisaKuota = globalTotalKuota - usedData;
    });
  }

  List<BarChartGroupData> getBarData() {
    return List.generate(dataBulanan.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dataBulanan[index] * _animation.value,
            color: Colors.blueAccent,
            width: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double terpakai = globalTotalKuota - globalSisaKuota;
    double progress = globalTotalKuota == 0 ? 0 : terpakai / globalTotalKuota;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('KUOTA MONITOR'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👋 SAPAAN
              Text(
                namaUser.isEmpty
                    ? "Halo, Selamat Datang!"
                    : "Halo, $namaUser 👋",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pemakaian Kuota",
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${terpakai.toStringAsFixed(1)} / $globalTotalKuota GB",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _buildInfoCard(
                    "Total",
                    "${total.toStringAsFixed(1)} GB",
                    Icons.data_usage,
                    Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  _buildInfoCard(
                    "Rata-rata",
                    "${rataRata.toStringAsFixed(1)} GB",
                    Icons.show_chart,
                    Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Riwayat Pemakaian Bulanan 📊",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 220,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return BarChart(
                      BarChartData(
                        maxY: 6,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: true),

                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${value.toInt() + 1}",
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),

                        barGroups: getBarData(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              const Text("📌 Angka bawah = tanggal"),
              const Text("📌 Tinggi batang = GB dipakai"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 5),
            Text(title),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
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
      globalTotalKuota =
          double.tryParse(_kuotaController.text) ?? globalTotalKuota;
      globalSisaKuota = globalTotalKuota;
    });

    widget.onSave();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data tersimpan")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: _kuotaController,
              decoration: const InputDecoration(labelText: "Kuota (GB)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: simpanData, child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
