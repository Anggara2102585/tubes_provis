import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'topup_page.dart';
import '../marketplace/marketplace_page.dart';
import '../portofolio/portofolio_page.dart';
import '../profil/profil_page.dart';
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

  void _tarikDana() {
    if (nomorRekeningController.text.isEmpty) {
      _showErrorDialog('Nomor Rekening belum diisi');
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
          title: Text(
            'Sukses',
          ),
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
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: Text(
                  'Tarik',
                  style: bodyBoldTextStyle,
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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }

    // Navigate to the corresponding page based on the selected index
    switch (_selectedIndex) {
      case 0:
        // Do nothing or handle home page logic
        break;
      case 1:
        Navigator.pushNamed(context, '/marketplace');
        break;
      case 2:
        Navigator.pushNamed(context, '/portofolio');
        break;
      case 3:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }
}

class TarikDanaPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beranda',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TarikDanaPage(),
      routes: {
        '/notification': (context) => NotificationPage(),
        '/topup': (context) => TopUpPage(),
        '/withdraw': (context) => TarikDanaPage(),
        '/marketplace': (context) => MarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        '/profil': (context) => ProfilPage(),
      },
    );
  }
}
