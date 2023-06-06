import 'package:flutter/material.dart';

class TarikDanaPage extends StatefulWidget {
  @override
  _TarikDanaPageState createState() => _TarikDanaPageState();
}

class _TarikDanaPageState extends State<TarikDanaPage> {
  int _selectedIndex = 0;
  double saldo = 1000; // Saldo awal

  TextEditingController jumlahController = TextEditingController();
  TextEditingController nomorRekeningController = TextEditingController();

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _tarikDana() {
    String nomorRekening = nomorRekeningController.text.trim();
    if (nomorRekening.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Mohon lengkapi nomor rekening.'),
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
      return;
    }

    double jumlah = double.parse(jumlahController.text);
    setState(() {
      saldo -= jumlah;
    });
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
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

  @override
  void initState() {
    super.initState();
    originalJumlahController.text = jumlahController.text;
    originalNomorRekeningController.text = nomorRekeningController.text;
  }

  @override
  void dispose() {
    jumlahController.dispose();
    nomorRekeningController.dispose();
    originalJumlahController.dispose();
    originalNomorRekeningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarik Dana'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Jumlah',
              style: TextStyle(fontSize: 16),
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
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
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
            Text(
              'Saldo Tersedia: $saldo',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Alamat Pengiriman Dana',
              style: TextStyle(fontSize: 16),
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
                  const Text(
                    'Pilih bank yang akan digunakan:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    children: daftarBank.map((String val) {
                      return ListTile(
                        title: Text(
                          val,
                          style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nomorRekeningController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18),
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
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: Text(
                  'Tarik',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Usahaku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green[100],
        onTap: _onItemTapped,
      ),
    );
  }
}
