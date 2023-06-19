import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum MetodeTopUp { transferBank, eWallet }

class _MyAppState extends State<MyApp> {
  MetodeTopUp selectedMetode = MetodeTopUp.transferBank;
  String selectedBank = 'BNI';
  String selectedEwallet = 'OVO';
  String topUpAmount = '0';
  int _selectedIndex = 0;
  late int id_akun;

  @override
  void initState() {
    super.initState();
    _getId();
  }

  void _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_akun = prefs.getInt('id_akun') ?? 0;
    });
    if (id_akun == 0) {
      _goToLoginPage();
    }
  }

  void _goToLoginPage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) =>
          false, // use (route) => false to remove all existing routes, effectively clearing the stack
    );
  }

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Top Up, $id_akun'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Masukkan jumlah top up:'),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: _handleTopUpAmountChange,
                    decoration: InputDecoration(
                      hintText: '0',
                      prefixText: 'Rp.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilih salah satu metode top up di bawah ini:'),
                  ListTile(
                    title: const Text('Transfer Bank'),
                    leading: Radio<MetodeTopUp>(
                      value: MetodeTopUp.transferBank,
                      groupValue: selectedMetode,
                      onChanged: _handleMetodeTopUpChange,
                    ),
                  ),
                  ListTile(
                    title: const Text('E-wallet'),
                    leading: Radio<MetodeTopUp>(
                      value: MetodeTopUp.eWallet,
                      groupValue: selectedMetode,
                      onChanged: _handleMetodeTopUpChange,
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
                          const Text('Pilih bank yang akan digunakan:'),
                          Wrap(
                            children: bankOptions.map((String val) {
                              return ListTile(
                                title: Text(val),
                                leading: Radio<String>(
                                  value: val,
                                  groupValue: selectedBank,
                                  onChanged: _handleBankChange,
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
                          const Text('Pilih e-wallet yang akan digunakan:'),
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
                      onPressed: () {
                        print('Selected Method: $selectedMetode');
                        print('Selected Bank: $selectedBank');
                        print('Selected e-Wallet: $selectedEwallet');
                        print('Top Up Amount: Rp.$topUpAmount');
                      },
                      child: Text('TOP UP'),
                    ),
                  ),
                ],
              ),
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
        ),
      ),
    );
  }
}
