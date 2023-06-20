import 'package:flutter/material.dart';
import '../../assets/font.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Portofolio {
  final String judul;
  final String deskripsi;
  final String tanggalAkhir;
  final bool selesai;

  Portofolio({
    required this.judul,
    required this.deskripsi,
    required this.tanggalAkhir,
    required this.selesai,
  });
}

class PortofolioPage extends StatefulWidget {
  @override
  _PortofolioPageState createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  int _selectedIndex = 2; // Set default selected index to 2 (Portofolio)

  // SharedPref
  int id_akun = 0;
  int jenis_user = 0;

  late List<Portofolio> portofolioList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
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
    final String apiUrl = 'http://127.0.0.1:8000/portofolio';
    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"id_akun": id_akun}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['pendanaan'] as List<dynamic>;
      final List<Map<String, dynamic>> dataList =
          data.cast<Map<String, dynamic>>();

      setState(() {
        portofolioList = dataList.map((item) {
          return Portofolio(
            judul: item['nama_umkm'] as String,
            deskripsi: item['kode_pendanaan'] as String,
            tanggalAkhir: item['tanggal_danai'] as String,
            selesai: item['status_pendanaan'] == 1,
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch data from the API');
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
        Navigator.pushReplacementNamed(context, '/beranda');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/marketplace');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portofolio',
          style: titleTextStyle,
        ),
      ),
      body: ListView.builder(
        itemCount: portofolioList.length,
        itemBuilder: (context, index) {
          Portofolio portofolio = portofolioList[index];
          return Card(
            child: ListTile(
              title: Text(
                portofolio.judul,
                style: bodyBoldTextStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portofolio.tanggalAkhir,
                    style: bodyTextStyle,
                  ),
                  Text(
                    portofolio.deskripsi,
                    style: bodyTextStyle,
                  ),
                ],
              ),
              trailing: Text(
                portofolio.selesai ? 'Selesai' : 'Belum Selesai',
                style: TextStyle(
                  color: portofolio.selesai ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/detail-portofolio');
              },
            ),
          );
        },
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
