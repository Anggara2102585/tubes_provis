import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../assets/font.dart';
import '../../shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Map<dynamic, dynamic>? _data = {
    'nama_pendana': '',
    'saldo': 0,
    'total_pendanaan': 0,
    'total_bagi_hasil': 0,
    'jumlah_didanai_aktif': 0,
    'umkm': [
      {
        'nama_umkm': '',
        'sisa_pokok': 0,
      },
    ],
  };

  int id_akun = 0;
  int jenis_user = 0;

  @override
  void initState() {
    super.initState();
    fetchDataOnce();
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

  Future<void> fetchDataOnce() async {
    final String apiUrl = 'http://127.0.0.1:8000/pendana/beranda';
    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_akun': id_akun}),
    );
    // Assuming the data fetched from the API is in the following format

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Fetch data successful, handle the response
      setState(() {
        _data = responseData; // Store the fetched data in the variable
        _data?['umkm'] = responseData['umkm'];
      });
      // _data = responseData;
    } else {
      // Registration failed, throw an exception or return an empty map
      throw Exception('An error occurred during registration.');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beranda',
          style: titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        // backgroundImage: AssetImage('profile_pic.jpeg'),
                        radius: 40,
                      ),
                      SizedBox(width: 24.0),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _data?['nama_pendana'] ?? '',
                              // '$id_akun',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/notification');
                    },
                    icon: Icon(Icons.notifications),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo',
                                  style: bodyBoldTextStyle,
                                ),
                                SizedBox(height: 8.0),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _data?['saldo'].toString() ?? '',
                                        // '$id_akun',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/topup');
                                },
                                icon: Column(
                                  children: [
                                    Icon(Icons.account_balance_wallet_outlined,
                                        size: 24.0),
                                  ],
                                ),
                                tooltip: 'Top Up',
                              ),
                              SizedBox(width: 16.0),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/tarikdana');
                                },
                                icon: Column(
                                  children: [
                                    Icon(Icons.currency_exchange, size: 24.0),
                                  ],
                                ),
                                tooltip: 'Tarik Dana',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Pendanaan Aktif',
                          style: bodyBoldTextStyle,
                        ),
                        SizedBox(height: 16.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                  'Anda sedang mendanai ',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                Text(
                                  _data?['jumlah_didanai_aktif'].toString() ??
                                      '',
                                  // '$id_akun',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(" Mitra")
                              ]),
                            ]),
                        SizedBox(height: 16.0),
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            final double containerWidth =
                                (constraints.maxWidth - 48.0) / 2;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: containerWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Pendanaan',
                                        style: bodyBoldTextStyle,
                                      ),
                                      SizedBox(height: 8.0),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _data?['total_pendanaan']
                                                      .toString() ??
                                                  '',
                                              // '$id_akun',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: containerWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Bagi Hasil',
                                        style: bodyBoldTextStyle,
                                      ),
                                      SizedBox(height: 8.0),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _data?['total_bagi_hasil']
                                                      .toString() ??
                                                  '',
                                              // '$id_akun',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text('Akun UMKM pendanaan aktif'),
                      SizedBox(height: 16.0),
                      Table(
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('UMKM'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Sisa Pokok'),
                                ),
                              ),
                            ],
                          ),
                          ..._data?['umkm'].map<TableRow>((umkm) {
                            return TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(umkm['nama_umkm']),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Rp ${umkm['sisa_pokok']}',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
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
        unselectedItemColor: Colors
            .green[100], // Set a very light green color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
