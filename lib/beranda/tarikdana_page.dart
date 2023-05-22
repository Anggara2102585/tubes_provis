import 'package:flutter/material.dart';
import '../assets/font.dart';

class TarikDanaPage extends StatefulWidget {
  @override
  _TarikDanaPageState createState() => _TarikDanaPageState();
}

class _TarikDanaPageState extends State<TarikDanaPage> {
  int _selectedIndex = 0;
  double saldo = 1000; // Saldo awal

  TextEditingController jumlahController = TextEditingController();
  TextEditingController nomorRekeningController = TextEditingController();

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
              style: bodyTextStyle,
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
                          activeColor: Colors.green,
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
                onPressed: () {
                  double jumlah = double.parse(jumlahController.text);
                  setState(() {
                    saldo -= jumlah;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: Text(
                  'Tarik',
                  style: bodyTextStyle,
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
            icon: Icon(Icons.shopping_cart),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Portofolio',
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
