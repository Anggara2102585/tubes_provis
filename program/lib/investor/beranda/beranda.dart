import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../assets/font.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                            '$id_akun',
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
                                  Navigator.pushNamed(context, '/tarikdana');
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Pendanaan Aktif',
                          style: bodyBoldTextStyle,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Anda sedang mendanai 0 mitra',
                          style: captionTextStyle,
                        ),
                        SizedBox(height: 16.0),
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            final double containerWidth =
                                (constraints.maxWidth - 48.0) / 2;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: containerWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  width: containerWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            );
                          },
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
                  child: Column(
                    children: <Widget>[
                      Text('Akun UMKM pendanaan aktif'),
                      SizedBox(height: 16.0),
                      Table(
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Nama UMKM'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Sisa Pokok'),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                            ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('UMKM 1'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Rp 500.000'),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('UMKM 2'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Rp 700.000'),
                                ),
                              ),
                            ],
                          ),
                          // Tambahkan baris lebih banyak jika diperlukan
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            //   child: Card(
            //     child: Padding(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            //       child: Card(
            //         child: Column(
            //           children: <Widget>[
            //             Container(
            //               padding: EdgeInsets.all(8.0),
            //               color: Colors
            //                   .green[200], // Accent color for the table header
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text('Nama UMKM'),
            //                   Text('Sisa Pokok'),
            //                 ],
            //               ),
            //             ),
            //             Table(
            //               defaultVerticalAlignment:
            //                   TableCellVerticalAlignment.middle,
            //               children: [
            //                 TableRow(
            //                   children: [
            //                     TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text('UMKM 1'),
            //                       ),
            //                     ),
            //                     TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text('Rp 500.000'),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 TableRow(
            //                   children: [
            //                     TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text('UMKM 2'),
            //                       ),
            //                     ),
            //                     TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text('Rp 700.000'),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 // Add more rows if needed
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
