import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class UMKM {
  final String logo;
  final String nama;
  final String jenisUsaha;
  final double limitPeminjaman;
  final bool lunas;
  final List<Pendanaan> daftarPendanaanBelumLunas;
  final List<Pendanaan> daftarPendanaanLunas;

  UMKM({
    required this.logo,
    required this.nama,
    required this.jenisUsaha,
    required this.limitPeminjaman,
    required this.lunas,
    required this.daftarPendanaanBelumLunas,
    required this.daftarPendanaanLunas,
  });
}

class Pendanaan {
  final String nama;
  final String deskripsi;
  final String tanggal;

  Pendanaan({
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  TextEditingController searchController = TextEditingController();
  List<UMKM> filteredUMKM = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<UMKM> daftarUMKM = [
    UMKM(
      logo: 'coba.jpg',
      nama: 'UMKM A',
      jenisUsaha: 'Jenis Usaha A',
      limitPeminjaman: 5000.0,
      lunas: false,
      daftarPendanaanBelumLunas: [
        Pendanaan(
          nama: 'Pendanaan A1',
          deskripsi: 'Deskripsi Pendanaan A1',
          tanggal: '21 Januari 2021',
        ),
        Pendanaan(
          nama: 'Pendanaan A2',
          deskripsi: 'Deskripsi Pendanaan A2',
          tanggal: '21 Januari 2022',
        ),
      ],
      daftarPendanaanLunas: [
        Pendanaan(
          nama: 'Pendanaan B1',
          deskripsi: 'Deskripsi Pendanaan B1',
          tanggal: '21 Januari 2023',
        ),
      ],
    ),
    // Add other UMKM objects here
  ];

  @override
  void initState() {
    super.initState();
    filteredUMKM = daftarUMKM;
  }

  void filterUMKM(String query) {
    List<UMKM> searchResult = daftarUMKM
        .where((umkm) => umkm.nama.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredUMKM = searchResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('UMKM Cards'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterUMKM,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUMKM.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CardWidget(
                        umkm: filteredUMKM[index],
                      ),
                      PendanaanWidgetBelumLunas(
                        daftarPendanaan:
                            filteredUMKM[index].daftarPendanaanBelumLunas,
                      ),
                      PendanaanWidgetLunas(
                        daftarPendanaan:
                            filteredUMKM[index].daftarPendanaanLunas,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
          currentIndex: 1, // Set the current index to 1 (Marketplace)
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.green[100],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final UMKM umkm;

  CardWidget({
    required this.umkm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                  //backgroundImage: AssetImage(umkm.logo),
                  ),
              title: Text(umkm.nama),
              subtitle: Text(umkm.jenisUsaha),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Limit: \$${umkm.limitPeminjaman.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Aksi yang ingin dilakukan saat tombol ditekan
                  },
                  child: Text('Upload Peminjaman'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PendanaanWidgetBelumLunas extends StatelessWidget {
  final List<Pendanaan> daftarPendanaan;

  PendanaanWidgetBelumLunas({
    required this.daftarPendanaan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Belum Lunas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: daftarPendanaan.map((pendanaan) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pendanaan.nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                child: Text('Bagi Hasil'),
                              ),
                            ],
                          ),
                          Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(pendanaan.deskripsi),
                          Text(
                            'Tanggal Pengajuan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(pendanaan.tanggal),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendanaanWidgetLunas extends StatelessWidget {
  final List<Pendanaan> daftarPendanaan;

  PendanaanWidgetLunas({
    required this.daftarPendanaan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sudah Lunas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: daftarPendanaan.map((pendanaan) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pendanaan.nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                child: Text('Profit'),
                              ),
                            ],
                          ),
                          Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(pendanaan.deskripsi),
                          Text(
                            'Tanggal Pengajuan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(pendanaan.tanggal),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
