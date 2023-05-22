import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'topup_page.dart';
import 'tarikdana_page.dart';
import '../marketplace/marketplace_page.dart';
import '../portofolio/portofolio_page.dart';
import '../profil/profil_page.dart';
import '../assets/font.dart';

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
      home: HomePage(),
      routes: {
        '/notification': (context) => NotificationPage(),
        '/topup': (context) => TopUpPage(),
        '/withdraw': (context) => TarikDanaPage(),
        '/marketplace': (context) => MarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        '/profil': (context) => ProfilPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        // Do nothing or handle home page logic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beranda',
          style: titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_pic.jpg'),
                        radius: 40,
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pengguna',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/notification');
                    },
                    icon: Icon(Icons.notifications),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo',
                                  style: bodyBoldTextStyle,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Rp 1.000.000',
                                  style: bodyTextStyle,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/topup');
                                },
                                icon: Column(
                                  children: [
                                    Icon(Icons.account_balance_wallet_outlined,
                                        size: 24.0),
                                  ],
                                ),
                                tooltip: 'Top Up',
                              ),
                              SizedBox(width: 16.0),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/withdraw');
                                },
                                icon: Column(
                                  children: [
                                    Icon(Icons.currency_exchange, size: 24.0),
                                  ],
                                ),
                                tooltip: 'Tarik Dana',
                              ),
                            ],
                          ),
                        ],
                      ),

                      // SizedBox(height: 16.0),
                      // Text(
                      //   'Rp 1.000.000',
                      //   style: TextStyle(fontSize: 24.0),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Laporan Keuangan',
                          style: bodyBoldTextStyle,
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          'Belum ada laporan',
                          style: bodyTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 48.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total Pendanaan',
                              style: bodyBoldTextStyle,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rp 1.000.000',
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 48.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bagi Hasil',
                              style: bodyBoldTextStyle,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rp 1.000.000',
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
        unselectedItemColor: Colors
            .green[100], // Set a very light green color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
