import 'package:flutter/material.dart';
import '../../assets/font.dart';
import '../../shared_pref.dart';

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
  final String minimal_pendanaan;
  final String tanggal;

  Pendanaan({
    required this.nama,
    required this.minimal_pendanaan,
    required this.tanggal,
  });
}

class DetailMarketplacePage extends StatefulWidget {
  const DetailMarketplacePage({super.key});

  @override
  DetailMarketplacePageState createState() => DetailMarketplacePageState();
}

class DetailMarketplacePageState extends State<DetailMarketplacePage> {
  int _selectedIndex = 0; // Set default selected index to 2 (Portofolio)

  //Sharedpref
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

  TextEditingController searchController = TextEditingController();
  List<UMKM> filteredUMKM = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          minimal_pendanaan: 'Deskripsi Pendanaan A1',
          tanggal: '21 Januari 2021',
        ),
        Pendanaan(
          nama: 'Pendanaan A2',
          minimal_pendanaan: 'Deskripsi Pendanaan A2',
          tanggal: '21 Januari 2022',
        ),
      ],
      daftarPendanaanLunas: [
        Pendanaan(
          nama: 'Pendanaan B1',
          minimal_pendanaan: 'Deskripsi Pendanaan B1',
          tanggal: '21 Januari 2023',
        ),
      ],
    ),
    // Add other UMKM objects here
  ];

  @override
  void initState() {
    super.initState();
    _initIdAkun();
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
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text('Detail'),
            ],
          ),
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
          onTap: _onItemTapped,
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
                    color: Colors.green,
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String nominal = '';

                                      return AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Apakah Anda yakin ingin mendanai?",
                                            ),
                                            SizedBox(height: 10),
                                            Text("Masukkan nominal:"),
                                            TextFormField(
                                              onChanged: (value) {
                                                nominal = value;
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
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('DANAI'),
                              ),
                            ],
                          ),
                          Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(pendanaan.minimal_pendanaan),
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
                          Text(pendanaan.minimal_pendanaan),
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
