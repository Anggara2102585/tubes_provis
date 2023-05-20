import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'topup_page.dart';
import 'withdraw_page.dart';
import '../marketplace/marketplace_page.dart';
import '../portofolio/portofolio_page.dart';
import '../profil/profil_page.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        '/notification': (context) => NotificationPage(),
        '/topup': (context) => TopUpPage(),
        '/withdraw': (context) => WithdrawPage(),
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
    setState(() {
      _selectedIndex = index;
    });

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
        title: Text('Beranda'),
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
                        backgroundImage: AssetImage('assets/profile_pic.jpg'),
                        radius: 40,
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pengguna',
                            style: TextStyle(fontSize: 20.0),
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
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
                                  'Saldo Anda',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Rp 1.000.000',
                                  style: TextStyle(fontSize: 14.0),
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
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Laporan Keuangan',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Belum ada laporan',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rp 1.000.000',
                              style: TextStyle(fontSize: 18.0),
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
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rp 1.000.000',
                              style: TextStyle(fontSize: 18.0),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors
            .blue[100], // Set a very light blue color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
