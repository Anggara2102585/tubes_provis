import 'package:flutter/material.dart';
import '../../shared_pref.dart';

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
      String deskripsi = _deskripsiController.text;
      int imba = int.parse(_imbaController.text);
      double minimal = double.parse(_minimalController.text);
      double totalDana = double.parse(_totalController.text);
      int penggalangan = int.parse(_dlPenggalanganController.text);

      // Lakukan sesuatu dengan data yang diinputkan
      // Misalnya, simpan ke database atau lakukan validasi lainnya

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
