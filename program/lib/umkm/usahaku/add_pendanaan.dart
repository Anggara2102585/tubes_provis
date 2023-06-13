import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PendanaanForm());
}

class PendanaanForm extends StatefulWidget {
  @override
  _PendanaanFormState createState() => _PendanaanFormState();
}

class _PendanaanFormState extends State<PendanaanForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _jumlahController = TextEditingController();

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proses submit form
      String judul = _judulController.text;
      String deskripsi = _deskripsiController.text;
      double jumlah = double.parse(_jumlahController.text);

      // Lakukan sesuatu dengan data yang diinputkan
      // Misalnya, simpan ke database atau lakukan validasi lainnya

      // Setelah berhasil, bisa menavigasi ke halaman lain atau memberikan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pendanaan baru berhasil ditambahkan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pendanaan Baru'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Pendanaan',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Judul pendanaan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Pendanaan',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Deskripsi pendanaan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Pendanaan',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Jumlah pendanaan harus diisi';
                  }
                  // Cek apakah nilai yang dimasukkan merupakan angka
                  if (double.tryParse(value) == null) {
                    return 'Jumlah pendanaan harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
