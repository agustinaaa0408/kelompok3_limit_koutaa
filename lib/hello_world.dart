import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  static const platform = MethodChannel('limit_kuota/channel');

  Future<String> _callKotlin() async {
    final String result =
        await platform.invokeMethod('sayHello');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('MethodChannel Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final msg = await _callKotlin();
              print(msg);
            },
            child: const Text('Panggil Kotlin'),
          ),
        ),
      ),
    );
  }
}
