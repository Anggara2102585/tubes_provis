/* FOLDER INI DIGUNAKAN UNTUK MENGUMPULKAN WIDGETS TEMPLATE */
/* File ini sebagai contoh salah satu template yaitu text */

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  /* variables, dispose, initstate, etc */
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Templates',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Templates'),
        ),
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [ // hapus const jika widget bisa berubah
// =====================================================

            Text('Replace widget ini'),
            Text('Bisa taruh beberapa widgets'),

// =====================================================
          ],
        )),
      ),
    );
  }
}
