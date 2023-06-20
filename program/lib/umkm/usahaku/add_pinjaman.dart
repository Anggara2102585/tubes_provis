import 'package:flutter/material.dart';
import '../../shared_pref.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../assets/font.dart';
import 'package:dio/dio.dart';

class PinjamanForm extends StatefulWidget {
  @override
  _PinjamanFormState createState() => _PinjamanFormState();
}

class _PinjamanFormState extends State<PinjamanForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _imbaController = TextEditingController();
  TextEditingController _minimalController = TextEditingController();
  TextEditingController _totalController = TextEditingController();
  TextEditingController _dlPenggalanganController = TextEditingController();

  //SharedPref
  int id_akun = 0;
  int jenis_user = 0;
  String deskripsi_pendanaan = "";
  int imba_hasil = 0;
  int minimal_pendanaan = 0;
  int dl_penggalangan_dana = 0;
  int total_pendanaan = 0;

  @override
  void initState() {
    super.initState();
    _initIdAkun();
  }

  Future<void> _initIdAkun() async {
    MySharedPrefs sharedPrefs = MySharedPrefs();
    await sharedPrefs.getId(context);
    setState(() {
      id_akun = sharedPrefs.id_akun;
      jenis_user = sharedPrefs.jenis_user;
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    final String apiUrl = 'http://127.0.0.1:8000/mengajukan_pendanaan';

    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_akun': id_akun,
        'deskripsi_pendanaan': deskripsi_pendanaan,
        'imba_hasil': imba_hasil,
        'minimal_pendanaan': minimal_pendanaan,
        'dl_penggalangan_dana': dl_penggalangan_dana,
        'total_pendanaan': total_pendanaan,
      }),
    );

    final responseData = jsonDecode(response.body);
    final Map<String, dynamic> data = {
      'deskripsi_pendanaan': responseData['deskripsi_pendanaan'] ?? '',
      'imba_hasil': responseData['imba_hasil'] ?? 0,
      'minimal_pendanaan': responseData['minimal_pendanaan'] ?? 0,
      'dl_penggalangan_dana': responseData['dl_penggalangan_dana'] ?? 0,
      'total_pendanaan': responseData['total_pendanaan'] ?? 0,
    };

    if (response.statusCode == 200) {
      // Fetch data successful, handle the response
      return data;
    } else {
      // Registration failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Fetch Data Failed'),
          content: Text('An error occurred during registration.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return {};
    }
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    _imbaController.dispose();
    _minimalController.dispose();
    _totalController.dispose();
    _dlPenggalanganController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proses submit form
      deskripsi_pendanaan = _deskripsiController.text;
      imba_hasil = int.parse(_imbaController.text);
      minimal_pendanaan = int.parse(_minimalController.text);
      total_pendanaan = int.parse(_totalController.text);
      dl_penggalangan_dana = int.parse(_dlPenggalanganController.text);

      // Lakukan sesuatu dengan data yang diinputkan
      // Misalnya, simpan ke database atau lakukan validasi lainnya
      setState(() {
        fetchData();
      });
      // Setelah berhasil, bisa menavigasi ke halaman lain atau memberikan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pinjaman baru berhasil ditambahkan'),
        ),
      );
      Navigator.of(context).pop(); // Tutup dialog setelah submit
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Form Pinjaman'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Pinjaman',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Deskripsi Pinjaman harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imbaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bagi Hasil',
                  suffixText: '%',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bagi Hasil harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (int.tryParse(value) == null) {
                    return 'Bagi Hasil harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _minimalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minimal Pendanaan',
                  suffixText: 'Rp',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Minimal Pendanaan harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (double.tryParse(value) == null) {
                    return 'Minimal Pendanaan harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Maksimum Pinjaman',
                  suffixText: 'Rp',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Maksimum Pinjaman harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (double.tryParse(value) == null) {
                    return 'Maksimum Pinjaman harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dlPenggalanganController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Deadline Penggalangan Dana',
                  suffixText: 'hari lagi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deadline Penggalangan Dana harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (int.tryParse(value) == null) {
                    return 'Deadline Penggalangan Dana harus berupa angka';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Tutup dialog saat tombol dibatalkan ditekan
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
