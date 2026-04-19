import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:limit_kuota/main.dart';
import 'package:limit_kuota/src/features/monitoring/network_page.dart';
import 'package:limit_kuota/src/features/monitoring/setting_page.dart';

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
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF12121F) : Colors.grey[100],
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
        );
      },
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

  // ✅ Estimasi kuota habis
  String get estimasiKuotaHabis {
    if (rataRata <= 0) return "Tidak diketahui";
    final sisaHari = globalSisaKuota / rataRata;
    if (sisaHari <= 0) return "Kuota sudah habis!";
    final tanggalHabis = DateTime.now().add(Duration(days: sisaHari.floor()));
    final bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return "${tanggalHabis.day} ${bulan[tanggalHabis.month]} ${tanggalHabis.year}";
  }

  String get sisaHariEstimasi {
    if (rataRata <= 0) return "-";
    final sisaHari = globalSisaKuota / rataRata;
    if (sisaHari <= 0) return "0";
    return "${sisaHari.floor()} hari lagi";
  }

  Color get estimasiColor {
    if (rataRata <= 0) return Colors.grey;
    final sisaHari = globalSisaKuota / rataRata;
    if (sisaHari <= 3) return Colors.red;
    if (sisaHari <= 7) return Colors.orange;
    return Colors.green;
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getDataUsage() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      usedData = 2.5;
      globalSisaKuota = globalTotalKuota - usedData;
    });
  }

  List<BarChartGroupData> getBarData(bool isDark) {
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
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, child) {
        final bgColor = isDark ? const Color(0xFF12121F) : Colors.grey[100]!;
        final cardColor = isDark ? const Color(0xFF2A2A3E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
        final chartTextColor = isDark ? Colors.white70 : Colors.black54;
        final gridColor = isDark ? Colors.white12 : Colors.grey.shade300;

        double terpakai = globalTotalKuota - globalSisaKuota;
        double progress = globalTotalKuota == 0
            ? 0
            : terpakai / globalTotalKuota;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('KUOTA MONITOR'),
            centerTitle: true,
            backgroundColor: isDark
                ? const Color(0xFF1E1E2E)
                : Colors.blueAccent,
            foregroundColor: Colors.white,
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📊 PROGRESS KUOTA
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1A237E), const Color(0xFF0D47A1)]
                            : [Colors.blueAccent, Colors.blue.shade800],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pemakaian Kuota",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${terpakai.toStringAsFixed(1)} / $globalTotalKuota GB",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Sisa: ${globalSisaKuota.toStringAsFixed(1)} GB",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ⏳ ESTIMASI KUOTA HABIS
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: estimasiColor.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: estimasiColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.hourglass_bottom_rounded,
                            color: estimasiColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Estimasi Kuota Habis",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                estimasiKuotaHabis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: estimasiColor,
                                ),
                              ),
                              Text(
                                sisaHariEstimasi,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rata-rata/hari",
                              style: TextStyle(
                                fontSize: 11,
                                color: subtitleColor,
                              ),
                            ),
                            Text(
                              "${rataRata.toStringAsFixed(1)} GB",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🌐 DETAIL JARINGAN
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.analytics,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        "Cek Detail Jaringan",
                        style: TextStyle(color: textColor),
                      ),
                      trailing: Icon(Icons.arrow_forward, color: subtitleColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Network()),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📈 INFO CARD
                  Row(
                    children: [
                      _buildInfoCard(
                        "Total",
                        "${total.toStringAsFixed(1)} GB",
                        Icons.data_usage,
                        Colors.blue,
                        textColor,
                        isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildInfoCard(
                        "Rata-rata",
                        "${rataRata.toStringAsFixed(1)} GB",
                        Icons.show_chart,
                        Colors.orange,
                        textColor,
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Riwayat Pemakaian Bulanan 📊",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📊 BAR CHART
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      height: 220,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return BarChart(
                            BarChartData(
                              maxY: 6,
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (value) =>
                                    FlLine(color: gridColor, strokeWidth: 1),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        "${value.toInt() + 1}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: chartTextColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        "${value.toInt()}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: chartTextColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups: getBarData(isDark),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "📌 Angka bawah = tanggal",
                    style: TextStyle(color: subtitleColor),
                  ),
                  Text(
                    "📌 Tinggi batang = GB dipakai",
                    style: TextStyle(color: subtitleColor),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color textColor,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: isDark ? Border.all(color: color.withOpacity(0.3)) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 5),
            Text(title, style: TextStyle(color: textColor)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
