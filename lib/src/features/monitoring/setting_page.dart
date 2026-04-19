import 'package:flutter/material.dart';
import 'package:limit_kuota/main.dart';

String namaUser = "";
double globalTotalKuota = 10;
double globalSisaKuota = 4;

class SettingPage extends StatefulWidget {
  final VoidCallback onSave;

  const SettingPage({super.key, required this.onSave});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();

  bool _notifikasi = true;
  bool _autoRefresh = true;
  String _periodeKuota = '30';

  final List<String> _periodeOptions = ['30', '90', 'Custom'];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    _namaController.text = namaUser;
    _kuotaController.text = globalTotalKuota.toString();
  }

  void simpanData() {
    setState(() {
      namaUser = _namaController.text.trim().isEmpty
          ? ""
          : _namaController.text.trim();
      final newTotalKuota = double.tryParse(_kuotaController.text) ?? 10.0;
      globalTotalKuota = newTotalKuota > 0 ? newTotalKuota : 10.0;
      globalSisaKuota = globalTotalKuota;
    });

    widget.onSave();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text("Pengaturan berhasil disimpan!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _resetKuota() {
    setState(() {
      globalSisaKuota = globalTotalKuota;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 10),
              Text("Kuota berhasil direset!"),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Ambil warna dari Theme Flutter (otomatis ikut light/dark)
    final theme = Theme.of(context);
    final isDark = darkModeNotifier.value;

    final bgColor = isDark ? const Color(0xFF12121F) : Colors.grey[50]!;
    final cardColor = isDark ? const Color(0xFF2A2A3E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final inputFillColor = isDark ? const Color(0xFF1E1E2E) : Colors.grey[50]!;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey.shade300;

    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text(
              "⚙️ Pengaturan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: isDarkMode
                ? const Color(0xFF1E1E2E)
                : Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: "Simpan",
                onPressed: simpanData,
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 INFO PENGGUNA
                _buildSection(
                  "👤 Info Pengguna",
                  [
                    _buildTextField(
                      controller: _namaController,
                      label: "Nama Lengkap",
                      icon: Icons.person_outline,
                      hint: "Masukkan nama Anda",
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      inputFillColor: inputFillColor,
                      borderColor: borderColor,
                    ),
                  ],
                  textColor: textColor,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 25),

                /// 📊 PENGATURAN KUOTA
                _buildSection(
                  "📊 Pengaturan Kuota",
                  [
                    _buildTextField(
                      controller: _kuotaController,
                      label: "Total Kuota (GB)",
                      icon: Icons.data_usage,
                      hint: "10.0",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      inputFillColor: inputFillColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 15),
                    _buildActionButtons(textColor, borderColor),
                  ],
                  textColor: textColor,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 25),

                /// ⚙️ TAMPILAN & NOTIFIKASI
                _buildSection(
                  "⚙️ Tampilan & Notifikasi",
                  [
                    _buildSwitchTile(
                      title: "Notifikasi Pengingat",
                      subtitle: "Peringatan saat kuota < 20%",
                      value: _notifikasi,
                      icon: Icons.notifications_active_outlined,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onChanged: (value) => setState(() => _notifikasi = value),
                    ),
                    _buildSwitchTile(
                      title: "Mode Gelap",
                      subtitle: "Tampilan tema gelap",
                      value: isDarkMode,
                      icon: Icons.dark_mode_outlined,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onChanged: (value) {
                        darkModeNotifier.value = value;
                      },
                    ),
                    _buildSwitchTile(
                      title: "Auto Refresh",
                      subtitle: "Perbarui data setiap 5 menit",
                      value: _autoRefresh,
                      icon: Icons.refresh_outlined,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onChanged: (value) =>
                          setState(() => _autoRefresh = value),
                    ),
                  ],
                  textColor: textColor,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 25),

                /// 📅 PERIODE MONITORING
                _buildSection(
                  "📅 Periode Monitoring",
                  [
                    DropdownButtonFormField<String>(
                      value: _periodeKuota,
                      dropdownColor: cardColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blueAccent,
                        ),
                        labelText: "Periode Grafik",
                        labelStyle: TextStyle(color: subtitleColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: inputFillColor,
                      ),
                      style: TextStyle(color: textColor),
                      items: _periodeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == 'Custom' ? 'Kustom' : '$value hari',
                            style: TextStyle(color: textColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _periodeKuota = value!),
                    ),
                  ],
                  textColor: textColor,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 30),

                /// ℹ️ TENTANG APLIKASI
                _buildSection(
                  "ℹ️ Tentang Aplikasi",
                  [_buildInfoTile(textColor, subtitleColor)],
                  textColor: textColor,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 30),

                /// BUTTON SIMPAN
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: simpanData,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text(
                      "SIMPAN SEMUA PENGATURAN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    String title,
    List<Widget> children, {
    required Color textColor,
    required Color cardColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 2,
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color textColor,
    required Color subtitleColor,
    required Color inputFillColor,
    required Color borderColor,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        labelStyle: TextStyle(color: subtitleColor),
        hintText: hint,
        hintStyle: TextStyle(color: subtitleColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Color textColor, Color borderColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _resetKuota,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text("Reset Kuota"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showKuotaHelp(textColor),
            icon: Icon(Icons.help_outline, color: textColor),
            label: Text("Bantuan", style: TextStyle(color: textColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color textColor,
    required Color subtitleColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.blueAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(Color textColor, Color subtitleColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue.shade700],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.info_outline, color: Colors.white, size: 24),
      ),
      title: Text(
        "Kuota Monitor v1.0.0",
        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      ),
      subtitle: Text(
        "Monitoring kuota internet harian",
        style: TextStyle(color: subtitleColor),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => showAboutDialog(
        context: context,
        applicationName: "Kuota Monitor",
        applicationVersion: "1.0.0",
        applicationIcon: const Icon(
          Icons.data_usage,
          size: 48,
          color: Colors.blueAccent,
        ),
        children: const [
          Text(
            "Aplikasi untuk memantau dan mengelola penggunaan kuota internet harian Anda.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showKuotaHelp(Color textColor) {
    final isDark = darkModeNotifier.value;
    final cardColor = isDark ? const Color(0xFF2A2A3E) : Colors.white;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Text("Panduan Kuota", style: TextStyle(color: textColor)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "• Masukkan total kuota paket Anda",
              style: TextStyle(color: textColor),
            ),
            Text(
              "• Tekan 'Reset Kuota' untuk mulai monitoring baru",
              style: TextStyle(color: textColor),
            ),
            Text(
              "• Kuota tersisa akan otomatis terupdate",
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            Text(
              "💡 Tips: Reset kuota setiap awal bulan!",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Mengerti"),
          ),
        ],
      ),
    );
  }
}
