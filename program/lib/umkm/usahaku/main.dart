import 'package:flutter/material.dart';
import 'pendanaan_belum_lunas.dart';
import 'pendanaan_lunas.dart';
import '../beranda/beranda.dart';

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
        '/pendanaan_belum_lunas': (context) => PendanaanBelumLunas(),
        '/pendanaan_lunas': (context) => PendanaanLunas(),
        '/beranda': (context) => HomePage(),
      },
    );
  }
}

class UsahakuPage extends StatefulWidget {
  @override
  _UsahakuPageState createState() => _UsahakuPageState();
}

class _UsahakuPageState extends State<UsahakuPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (_selectedIndex) {
      case 0:
        // Do nothing or handle home page logic
        break;
      case 1:
        Navigator.pushNamed(context, '/beranda');
        break;
      case 2:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  double _persentasePendanaan = 60.0; // Persentase pendanaan (contoh)

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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Cari Pendanaan',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Lakukan logika pencarian di sini
                    },
                    child: Text('Cari'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pendanaan Belum Lunas',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 8.0),
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
                        Navigator.pushNamed(context, '/pendanaan_belum_lunas');
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
                                      'Tanggal Pengajuan',
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
                                  'Judul Pendanaan',
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
                                        // Aksi ketika tombol "Bayar" ditekan
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
            SizedBox(height: 14.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Status Pendanaan',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: CircularProgressIndicator(
                          value: _persentasePendanaan / 100,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 92, 129, 95)),
                          strokeWidth: 10.0,
                        ),
                      ),
                      Text(
                        '${_persentasePendanaan.toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pendanaan Lunas',
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
                        Navigator.pushNamed(context, '/pendanaan_lunas');
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
                                  'Judul Pendanaan',
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
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Aksi ketika tombol "Profit" ditekan
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
