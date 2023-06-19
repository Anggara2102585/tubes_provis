import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketplaceCubit extends ChangeNotifier {
  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void showFilterOptions() {}
}

class MarketplacePage extends StatelessWidget {
  Future<List<dynamic>> fetchData() async {
    final String apiUrl = 'http://127.0.0.1:8000/marketplace';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to fetch data from the API');
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
                    final String namaUmkm = item['nama_umkm'];
                    final int persenProgres = item['peersen_progres'];
                    final double totalPendanaan = item['total_pendanaan'];
                    final String dlPenggalanganDana =
                        item['dl_penggalangan_dana'];
                    final int kodePendanaan = item['kode_pendanaan'];
                    final int imbaHasil = item['imba_hasil'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail-marketplace');
                      },
                      child: UMKMCard(
                        nama_umkm: namaUmkm,
                        peersen_progres: persenProgres,
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

class UMKMCard extends StatelessWidget {
  final String nama_umkm;
  final int peersen_progres;
  final double total_pendanaan;
  final String dl_penggalangan_dana;
  final int kode_pendanaan;
  final int imba_hasil;

  UMKMCard({
    required this.nama_umkm,
    required this.peersen_progres,
    required this.total_pendanaan,
    required this.dl_penggalangan_dana,
    required this.kode_pendanaan,
    required this.imba_hasil,
  });

  String formatCurrency(double amount) {
    String formattedValue = 'Rp ' +
        amount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match match) => '${match[1]}.',
            );
    return formattedValue;
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
                        nama_umkm,
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
                          'Id: $kode_pendanaan',
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
                          '$imba_hasil%',
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
                Column(
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
                          '$peersen_progres%',
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
                      'Jumlah Pinjaman: ${formatCurrency(total_pendanaan)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Tanggal: $dl_penggalangan_dana',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
