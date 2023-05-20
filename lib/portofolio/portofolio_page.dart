import 'package:flutter/material.dart';
import '../marketplace/marketplace_page.dart';
import '../profil/profil_page.dart';
import '../beranda/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class PortofolioPage extends StatefulWidget {
  @override
  _PortofolioPageState createState() => _PortofolioPageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beranda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/beranda', // Set the initial route to '/beranda'
      routes: {
        '/beranda': (context) => HomePage(),
        '/marketplace': (context) => MarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        '/profil': (context) => ProfilPage(),
      },
    );
  }
}

class PortofolioStatePage extends StatefulWidget {
  @override
  _PortofolioPageState createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  int _selectedIndex = 2; // Set default selected index to 1 (Portofolio)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacementNamed(context,
            '/beranda'); // Use pushReplacementNamed to replace the current page
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
        title: Text('Portofolio'),
      ),
      body: Center(
        child: Text('Portofolio'),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue[100],
        onTap: _onItemTapped,
      ),
    );
  }
}
