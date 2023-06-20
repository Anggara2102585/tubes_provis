import 'package:flutter/material.dart';
import '../../assets/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum MetodeTopUp { transferBank, eWallet }

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  int _selectedIndex = 0;
  int id_akun = 0;
  int jenis_user = 0;
  int nominal = 0;

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

  Future<void> fetchData() async {
    final String apiUrl = 'http://127.0.0.1:8000/topup';

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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sukses',
          ),
          backgroundColor: Colors.green,
          content: Text('Berhasil TopUp.'),
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

  TextEditingController jumlahController = TextEditingController();

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
        Navigator.pushNamed(context, '/beranda');
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

  MetodeTopUp selectedMetode = MetodeTopUp.transferBank;
  String selectedBank = 'BNI';
  String selectedEwallet = 'OVO';
  String topUpAmount = '0';

  final List<String> bankOptions = [
    'BNI',
    'BCA',
    'Mandiri',
    'BRI',
  ];
  final List<String> ewalletOptions = [
    'OVO',
    'Gopay',
    'ShopeePay',
  ];

  void _handleMetodeTopUpChange(MetodeTopUp? value) {
    if (value != null) {
      setState(() {
        selectedMetode = value;
        selectedBank = bankOptions.first;
        selectedEwallet = ewalletOptions.first;
      });
    }
  }

  void _handleBankChange(String? value) {
    if (value != null) {
      setState(() {
        selectedBank = value;
      });
    }
  }

  void _handleEwalletChange(String? value) {
    if (value != null) {
      setState(() {
        selectedEwallet = value;
      });
    }
  }

  void _handleTopUpAmountChange(String value) {
    setState(() {
      topUpAmount = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Top Up', // disini tambahin var id akun
              style: titleTextStyle,
            ),
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Masukkan jumlah top up:',
                    style: bodyBoldTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  const SizedBox(height: 16),
                  Text(
                    'Pilih salah satu metode top up di bawah ini:',
                    style: bodyBoldTextStyle,
                  ),
                  ListTile(
                    title: Text(
                      'Transfer Bank',
                      style: bodyTextStyle,
                    ),
                    leading: Radio<MetodeTopUp>(
                      value: MetodeTopUp.transferBank,
                      groupValue: selectedMetode,
                      onChanged: _handleMetodeTopUpChange,
                      activeColor: Colors.green,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'E-wallet',
                      style: bodyTextStyle,
                    ),
                    leading: Radio<MetodeTopUp>(
                      value: MetodeTopUp.eWallet,
                      groupValue: selectedMetode,
                      onChanged: _handleMetodeTopUpChange,
                      activeColor: Colors.green,
                    ),
                  ),
                  if (selectedMetode == MetodeTopUp.transferBank)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih bank yang akan digunakan:',
                            style: bodyBoldTextStyle,
                          ),
                          Wrap(
                            children: bankOptions.map((String val) {
                              return ListTile(
                                title: Text(val),
                                leading: Radio<String>(
                                  value: val,
                                  groupValue: selectedBank,
                                  onChanged: _handleBankChange,
                                  activeColor: Colors.green,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  if (selectedMetode == MetodeTopUp.eWallet)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih e-wallet yang akan digunakan:',
                            style: bodyBoldTextStyle,
                          ),
                          Wrap(
                            children: ewalletOptions.map((String val) {
                              return ListTile(
                                title: Text(val),
                                leading: Radio<String>(
                                  value: val,
                                  groupValue: selectedEwallet,
                                  onChanged: _handleEwalletChange,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        // print('Selected Method: $selectedMetode');
                        // print('Selected Bank: $selectedBank');
                        // print('Selected e-Wallet: $selectedEwallet');
                        // print('Top Up Amount: Rp.$topUpAmount');

                        await fetchData();
                        _showSuccessDialog();
                        // print(data);
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.green, // Mengubah warna button menjadi hijau
                      ),
                      child: Text(
                        'TOP UP',
                        style: subtitleTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
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
        ),
      ),
    );
  }
}
