import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';
import '../../assets/font.dart';

class TarikDanaPage extends StatefulWidget {
  @override
  _TarikDanaPageState createState() => _TarikDanaPageState();
}

class _TarikDanaPageState extends State<TarikDanaPage> {
  int _selectedIndex = 0;
  double saldo = 0; // Saldo awal

  double nominal = 0;
  int id_akun = 0;
  int jenis_user = 0;

  Future<void> _initIdAkun() async {
    MySharedPrefs sharedPrefs = MySharedPrefs();
    await sharedPrefs.getId(context);
    setState(() {
      id_akun = sharedPrefs.id_akun;
      jenis_user = sharedPrefs.jenis_user;
    });
  }

  Future<Map<String, double>> fetchDataSaldo() async {
    final String apiUrl = 'http://127.0.0.1:8000/saldo';

    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_akun': id_akun, 'jenis_user': jenis_user}),
    );

    if (response.statusCode == 200) {
      // Fetch data successful, handle the response
      final responseData = jsonDecode(response.body);
      final Map<String, double> data = {
        'saldo': responseData['saldo']?.toDouble() ?? 0.0,
      };
      setState(() {
        saldo = data['saldo'] ?? 0.0;
        saldoController.text = saldo.toStringAsFixed(2);
      });
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

  Future<void> fetchDataTarikDana(double jumlah) async {
    final String apiUrl = 'http://127.0.0.1:8000/tarik-dana';

    await _initIdAkun();
    double nominal = 0;
    try {
      nominal = double.parse(jumlahController.text);
    } catch (e) {
      print('Failed to parse omzet: $e');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'nominal': nominal, 'id_akun': id_akun, 'jenis_user': jenis_user}),
    );

    if (response.statusCode == 200) {
      // Fetch data successful, handle the response
      // ini ngedirect tpi gaperlu
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
    }
  }

  TextEditingController jumlahController = TextEditingController();
  TextEditingController nomorRekeningController = TextEditingController();
  TextEditingController saldoController = TextEditingController();

  TextEditingController originalJumlahController = TextEditingController();
  TextEditingController originalNomorRekeningController =
      TextEditingController();

  List<String> daftarBank = [
    'BNI',
    'BCA',
    'Mandiri',
    'BRI',
  ];
  String bankTerpilih = "BNI";

  void _handleBankChange(String? value) {
    setState(() {
      bankTerpilih = value!;
    });
  }

  void _tarikDana() async {
    if (nomorRekeningController.text.isEmpty) {
      _showErrorDialog('Nomor Rekening belum diisi');
      return;
    }

    double jumlah = double.tryParse(jumlahController.text) ?? 0.0;
    await fetchDataTarikDana(jumlah); // Mengirim data ke API
    fetchDataSaldo(); // Memperbarui saldo setelah berhasil
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sukses',
          ),
          backgroundColor: Colors.green,
          content: Text('Uang berhasil ditarik.'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  jumlahController.text = originalJumlahController.text;
                  nomorRekeningController.text =
                      originalNomorRekeningController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initIdAkun();
    fetchDataSaldo().then((saldoData) {
      setState(() {
        saldo = saldoData['saldo'] ?? 0.0;
        saldoController.text = saldo.toStringAsFixed(2);
      });
    });
    originalJumlahController.text = jumlahController.text;
    originalNomorRekeningController.text = nomorRekeningController.text;
  }

  @override
  void dispose() {
    jumlahController.dispose();
    nomorRekeningController.dispose();
    saldoController.dispose();
    originalJumlahController.dispose();
    originalNomorRekeningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarik Dana',
          style: titleTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Jumlah',
              style: bodyBoldTextStyle,
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Rp',
                      style: bodyTextStyle,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: jumlahController,
                      style: bodyTextStyle,
                      decoration: InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder<Map<String, double>>(
              future: fetchDataSaldo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final responseData = snapshot.data!;
                  saldoController.text =
                      responseData['saldo']?.toStringAsFixed(2) ?? '';

                  return Text(saldoController.text);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Alamat Pengiriman Dana',
              style: bodyBoldTextStyle,
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih bank yang akan digunakan:',
                    style: bodyTextStyle,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    children: daftarBank.map((String val) {
                      return ListTile(
                        title: Text(
                          val,
                          style: bodyTextStyle,
                        ),
                        leading: Radio<String>(
                          value: val,
                          groupValue: bankTerpilih,
                          onChanged: _handleBankChange,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No. Rekening',
              style: bodyBoldTextStyle,
            ),
            SizedBox(height: 8),
            TextField(
              controller: nomorRekeningController,
              keyboardType: TextInputType.number,
              style: bodyBoldTextStyle,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor rekening',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _tarikDana,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: buttonTextStyle,
                  primary: Colors.green,
                ),
                child: Text('Tarik Dana'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySharedPrefs {
  int id_akun = 0;
  int jenis_user = 0;

  Future<void> getId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_akun = prefs.getInt('id_akun') ?? 0;
    jenis_user = prefs.getInt('jenis_user') ?? 0;
  }
}
