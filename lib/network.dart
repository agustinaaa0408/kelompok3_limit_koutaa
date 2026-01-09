import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  static const platform = MethodChannel('limit_kuota/channel');

  String usageText = "Tekan tombol untuk cek";

  Future<void> fetchUsage() async {
    try {
      final int result = await platform.invokeMethod('getTodayUsage');
      // Hasil dalam satuan bytes, konversi ke MB:
      double mb = result / (1024 * 1024);
      print("Penggunaan hari ini: ${mb.toStringAsFixed(2)} MB");
      return setState(() {
        usageText = "Penggunaan data hari ini: ${mb.toStringAsFixed(2)} MB";
      });
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Limit Kuota Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                usageText,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchUsage,
                child: const Text('Cek Data Hari Ini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
