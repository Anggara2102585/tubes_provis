import 'package:flutter/material.dart';

import 'pinjaman_belum_lunas.dart';
import 'pinjaman_lunas.dart';
import 'add_pinjaman.dart';

import 'package:myapp/umkm/profil/edit_profilUmkm.dart';

import 'pinjaman_aktif.dart';

import '../beranda/beranda.dart';
import '../profil/profilUmkm.dart';
import 'package:myapp/investor/profil/pusatbantuan_page.dart';
import '../../shared_pref.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usahaku',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UsahakuPage(),
      routes: {
        '/pinjaman_belum_lunas': (context) => PinjamanBelumLunas(),
        '/pinjaman_lunas': (context) => PinjamanLunas(),
        '/pinjaman_aktif': (context) => PinjamanAktif(),
        '/beranda': (context) => HomePageUMKM(),
        '/profil': (context) => ProfilUmkmPage(),
        '/edit_profilUmkm': (context) => EditProfileUmkmPage(),
        '/pusatbantuan': (context) => const PusatBantuanPage(),
      },
    );
  }
}

class UsahakuPage extends StatefulWidget {
  @override
  _UsahakuPageState createState() => _UsahakuPageState();
}

class _UsahakuPageState extends State<UsahakuPage> {
  int _selectedIndex = 1;

  //SharedPref
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (_selectedIndex) {
      case 0:
        Navigator.pushNamed(context, '/berandaUMKM');
        break;
      case 1:
        // Do nothing or handle home page logic
        break;
      case 2:
        Navigator.pushNamed(context, '/profilUmkm');
        break;
    }
  }

  int adaBelumLunas = 2;
  double _persentasePinjaman = 60.0; // Persentase pinjaman (contoh)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usahaku'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/marketplace_logo.png'),
                        radius: 40,
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama UMKM',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            'Jenis Usaha',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Total Pinjaman: 4',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Total Pengeluaran: Rp 1.000.000',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            if (adaBelumLunas == 0 || adaBelumLunas == 2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Pinjaman Belum Lunas',
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            else if (adaBelumLunas == 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Pinjaman Aktif',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            SizedBox(height: 8.0),
            // belum ada pinjaman
            if (adaBelumLunas == 0)
              Column(
                children: [
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      'Anda belum memiliki pinjaman aktif. Buat baru!',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PinjamanForm();
                          },
                        );
                      },
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ],
              )
            // sudah ada pinjaman tpi masih ongoing
            else if (adaBelumLunas == 1)
              Container(
                width: double.infinity,
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1, // Ganti dengan jumlah kartu yang sebenarnya
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pinjaman_aktif');
                        },
                        child: Container(
                          width: 390.0,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Batas Penggalangan Dana',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      Text(
                                        'DD/MM/YYYY', // Ganti dengan tanggal yang sebenarnya
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Judul Pinjaman',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Deskripsi Singkat',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Aksi ketika area tombol "Bayar" ditekan
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            'Total: Rp 1.000.000',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            // waktunya bagi hasil
            else if (adaBelumLunas == 2)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1, // Ganti dengan jumlah kartu yang sebenarnya
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/pinjaman_belum_lunas');
                            },
                            child: Container(
                              width: 390.0,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Batas Bagi Hasil',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                          Text(
                                            'DD/MM/YYYY', // Ganti dengan tanggal yang sebenarnya
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Judul Pinjaman',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Deskripsi Singkat',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Pembayaran Berhasil!'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Menutup dialog
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Text('Bayar: Rp '),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Status Pinjaman',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 80.0,
                              width: 80.0,
                              child: CircularProgressIndicator(
                                value: _persentasePinjaman / 100,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 92, 129, 95)),
                                strokeWidth: 10.0,
                              ),
                            ),
                            Text(
                              '${_persentasePinjaman.toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pinjaman Lunas',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Ganti dengan jumlah kartu yang sebenarnya
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/pinjaman_lunas');
                      },
                      child: Container(
                        width: 300.0,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Tanggal Selesai',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text(
                                      'DD/MM/YYYY', // Ganti dengan tanggal yang sebenarnya
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Judul Pinjaman',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Status Pengembalian: Tidak Telat',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Aksi ketika area tombol "Bayar" ditekan
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          'Total: Rp 1.000.000',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
    );
  }
}
