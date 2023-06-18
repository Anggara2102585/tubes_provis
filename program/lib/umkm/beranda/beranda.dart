import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'topup_page.dart';
import 'withdraw_page.dart';
import '../usahaku/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: HomePageUMKM(),
      routes: {
        '/notification': (context) => NotificationPage(),
        '/topup': (context) => MyApp(),
        '/withdraw': (context) => TarikDanaPage(),
        '/usahaku': (context) => UsahakuPage(),
        // '/portofolio': (context) => PortofolioPage(),
        // '/profil': (context) => ProfilPage(),
      },
    );
  }
}

class HomePageUMKM extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageUMKM> {
  int _selectedIndex = 0;
  late int id_akun;

  @override
  void initState() {
    super.initState();
    _getId();
  }

  void _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_akun = prefs.getInt('id_akun') ?? 0;
    });
    if (id_akun == 0) {
      _goToLoginPage();
    }
  }

  void _goToLoginPage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) =>
          false, // use (route) => false to remove all existing routes, effectively clearing the stack
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/usahaku');
        break;
      case 2:
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
                            '$id_akun',
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
