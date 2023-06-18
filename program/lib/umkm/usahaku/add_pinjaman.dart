import 'package:flutter/material.dart';

class PinjamanForm extends StatefulWidget {
  @override
  _PinjamanFormState createState() => _PinjamanFormState();
}

class _PinjamanFormState extends State<PinjamanForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _imbaController = TextEditingController();
  TextEditingController _minimalController = TextEditingController();
  TextEditingController _dlPenggalanganController = TextEditingController();

  @override
  void dispose() {
    _deskripsiController.dispose();
    _imbaController.dispose();
    _minimalController.dispose();
    _dlPenggalanganController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proses submit form
      String deskripsi = _deskripsiController.text;
      String imba = _imbaController.text;
      double minimal = double.parse(_minimalController.text);
      String penggalangan = _dlPenggalanganController.text;

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
                    return 'Deskripsi pinjaman harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imbaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Imba Pinjaman',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Imba pinjaman harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _minimalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minimal Pinjaman',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Minimal pinjaman harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (double.tryParse(value) == null) {
                    return 'Minimal pinjaman harus berupa angka';
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
