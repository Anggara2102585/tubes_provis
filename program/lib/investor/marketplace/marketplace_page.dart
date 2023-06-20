import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../shared_pref.dart';

class MarketplaceCubit extends ChangeNotifier {
  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void showFilterOptions() {}
}

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int id_akun = 0;
  int jenis_user = 0;

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
  
  Future<List<dynamic>> fetchData() async {
    final String apiUrl = 'http://127.0.0.1:8000/marketplace';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['pendanaan'] as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to fetch data from the API');
    }
  }

  Future<void> danaiEndpoint(nominal, id_pendanaan) async {
    final String apiUrl = 'http://127.0.0.1:8000/mendanai';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_akun': id_akun,
        'nominal': nominal,
        'id_pendanaan': id_pendanaan
      }),
    );

    if (response.statusCode == 200) {
      // final responseData = jsonDecode(response.body);
      // final data = responseData['pendanaan'] as List<dynamic>;
      // return data;
    } else {
      throw Exception('Failed to send data to the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard UMKM'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<dynamic> data = snapshot.data!;

                return Column(
                  children: data.map((item) {
                    final int idPendanaan = item['id_pendanaan'];
                    final String namaUmkm = item['nama_umkm'];
                    final int persenProgres = item['persen_progres'];
                    final double totalPendanaan = item['total_pendanaan'];
                    final String dlPenggalanganDana =
                        item['dl_penggalangan_dana'];
                    final String kodePendanaan = item['kode_pendanaan'];
                    final int imbaHasil = item['imba_hasil'];

                    return GestureDetector(
                      // onTap: () {
                      //   Navigator.pushNamed(context, '/detail-marketplace');
                      // },
                      child: UMKMCard(
                        id_pendanaan: idPendanaan,
                        nama_umkm: namaUmkm,
                        persen_progres: persenProgres,
                        total_pendanaan: totalPendanaan,
                        dl_penggalangan_dana: dlPenggalanganDana,
                        kode_pendanaan: kodePendanaan,
                        imba_hasil: imbaHasil,
                      ),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data from the API');
              }

              return CircularProgressIndicator();
            },
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
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green[100],
        onTap: (index) {
          if (index == 1) {
            // Do nothing or handle marketplace page logic
          } else {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/beranda');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/portofolio');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profil');
                break;
            }
          }
        },
      ),
    );
  }
}

class UMKMCard extends StatefulWidget {
  final int id_pendanaan;
  final String nama_umkm;
  final int persen_progres;
  final double total_pendanaan;
  final String dl_penggalangan_dana;
  final String kode_pendanaan;
  final int imba_hasil;

  UMKMCard({
    required this.id_pendanaan,
    required this.nama_umkm,
    required this.persen_progres,
    required this.total_pendanaan,
    required this.dl_penggalangan_dana,
    required this.kode_pendanaan,
    required this.imba_hasil,
  });

  @override
  _UMKMCardState createState() => _UMKMCardState();
}

class _UMKMCardState extends State<UMKMCard> {
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

  Future<void> danaiEndpoint(nominal, id_pendanaan) async {
    final String apiUrl = 'http://127.0.0.1:8000/mendanai';
    await _initIdAkun();
    print(id_akun);
    print(id_pendanaan);
    print(nominal);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_akun': id_akun,
        'nominal': nominal,
        'id_pendanaan': id_pendanaan
      }),
    );

    if (response.statusCode == 200) {
      // final responseData = jsonDecode(response.body);
      // final data = responseData['pendanaan'] as List<dynamic>;
      // return data;
    } else {
      throw Exception('Failed to send data to the API');
    }
  }
  
  String nominal = '';

  String formatCurrency(double amount) {
    String formattedValue = 'Rp ' +
        amount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match match) => '${match[1]}.',
            );
    return formattedValue;
  }

  void showConfirmationDialog(int id_pendanaan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Apakah Anda yakin ingin mendanai?"),
              SizedBox(height: 10),
              Text("Masukkan nominal:"),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    nominal = value;
                  });
                },
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Iya"),
              onPressed: () {
                // Perform the DANAI action here
                if (nominal.isNotEmpty) {
                  // Use the nominal value here
                  print('Nominal: $nominal');
                  danaiEndpoint(nominal, id_pendanaan);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.nama_umkm,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Id: ${widget.kode_pendanaan}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          'Bagi Hasil',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${widget.imba_hasil}%',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Progress:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '${widget.persen_progres}%',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Pendanaan: ${formatCurrency(widget.total_pendanaan)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Tanggal: ${widget.dl_penggalangan_dana}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(widget.id_pendanaan);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: Text(
                    'DANAI',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}