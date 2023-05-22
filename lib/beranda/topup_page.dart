import 'package:flutter/material.dart';

enum MetodeTopUp { transferBank, eWallet }

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  MetodeTopUp selectedMetode = MetodeTopUp.transferBank;
  String selectedBank = 'BNI';
  String selectedEwallet = 'OVO';
  String topUpAmount = '0';
  int _selectedIndex = 0;

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
    if (index == _selectedIndex) {
      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Top Up'),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_back),
                label: 'Kembali',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.blue[100],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(TopUpPage());
}
