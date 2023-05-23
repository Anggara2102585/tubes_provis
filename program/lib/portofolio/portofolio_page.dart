import 'package:flutter/material.dart';
import '../marketplace/marketplace_page.dart';
import '../profil/profil_page.dart';
import '../beranda/main.dart';
import '../assets/font.dart';
import 'detail_portofolio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beranda',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => HomePage(),
        '/marketplace': (context) => MarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        // '/detail-portofolio': (context) => DetailPortofolioPage(),
        '/profil': (context) => ProfilPage(),
      },
    );
  }
}

class Portofolio {
  String judul;
  String deskripsi;
  String tanggalAkhir;
  bool selesai;

  Portofolio({
    required this.judul,
    required this.deskripsi,
    required this.tanggalAkhir,
    required this.selesai,
  });
}

class PortofolioPage extends StatefulWidget {
  @override
  Portofolio? _selectedPortofolio;
  _PortofolioPageState createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  int _selectedIndex = 2; // Set default selected index to 2 (Portofolio)

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
        Navigator.pushReplacementNamed(context, '/');
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

  List<Portofolio> listPortofolio = [
    Portofolio(
      judul: 'Pendanaan A',
      deskripsi: 'Deskripsi pendanaan A',
      tanggalAkhir: '30 Mei 2023',
      selesai: false,
    ),
    Portofolio(
      judul: 'Pendanaan B',
      deskripsi: 'Deskripsi pendanaan B',
      tanggalAkhir: '15 Juni 2023',
      selesai: true,
    ),
    Portofolio(
      judul: 'Pendanaan C',
      deskripsi: 'Deskripsi pendanaan C',
      tanggalAkhir: '10 Juli 2023',
      selesai: false,
    ),
  ];

  void _navigateToPortofolioPage(BuildContext context, Portofolio portofolio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPortofolioPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portofolio'),
      ),
      body: ListView.builder(
        itemCount: listPortofolio.length,
        itemBuilder: (context, index) {
          Portofolio portofolio = listPortofolio[index];
          return Card(
            child: ListTile(
              title: Text(portofolio.judul),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(portofolio.tanggalAkhir),
                  Text(portofolio.deskripsi),
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
                _navigateToPortofolioPage(context, portofolio);
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

// class DetailPortofolioPage extends StatelessWidget {
//   final Portofolio portofolio;

//   DetailPortofolioPage({required this.portofolio});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Portofolio'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Judul: ${portofolio.judul}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Deskripsi: ${portofolio.deskripsi}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Tanggal Akhir: ${portofolio.tanggalAkhir}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Status: ${portofolio.selesai ? 'Selesai' : 'Belum Selesai'}',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: portofolio.selesai ? Colors.green : Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
