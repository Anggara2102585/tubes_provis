import 'package:flutter/material.dart';
import '../marketplace/marketplace_page.dart';
import '../portofolio/portofolio_page.dart';
import '../beranda/main.dart';
import '../assets/font.dart';
import 'package:myapp/profil/pusatbantuan_page.dart';

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
      initialRoute: '/', // Set the initial route to '/beranda'
      routes: {
        '/': (context) => HomePage(),
        '/marketplace': (context) => MarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        '/profil': (context) => const ProfilPage(),
        '/pusatbantuan': (contex) => const PusatBantuanPage(),
      },
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  ProfilPageState createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  int _selectedIndex = 3; // Set default selected index to 1 (Profil)

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
        Navigator.pushReplacementNamed(context, '/'); // Use pushReplacementNamed to replace the current page
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/marketplace');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/portofolio');
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _ProfilPageContent(),
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

class _ProfilPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // SizedBox(height: 16.0),
          const SizedBox(
            width: double.infinity, // Set the container width to fit the screen
            child: _ProfileCard(
              profileImage: 'https://placehold.co/400x400.png',
              userName: 'John Doe',
            ),
          ),
          ListTile(
            title: const Text('Akun'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Handle 'Akun' button tap
              // Navigate to Akun page
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Pusat Bantuan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/pusatbantuan');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(
              Icons.exit_to_app,
              color: Colors.red
            ),
            onTap: () {
              // Handle 'Keluar' button tap
              // Perform logout action
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String profileImage;
  final String userName;

  const _ProfileCard({
    required this.profileImage,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              userName,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
