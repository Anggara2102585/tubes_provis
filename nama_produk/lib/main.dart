/* FILE INI DIGUNAKAN UNTUK ROUTING */

import 'package:flutter/material.dart';
// import 'package:nama_produk/pages/umkm/file.dart';
// import 'package:nama_produk/pages/pendana/file.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Text("Hello Tubes :D"),
      '/umkm/': (context) => Text("Selamat datang Pemilik UMKM"),
      '/umkm/usahaku': (context) => Text("Usahaku"),
      '/pendana/': (context) => Text("Selamat dantang Pendana"),
      '/pendana/portofolio': (context) => Text("Portofolio"),
    }
));