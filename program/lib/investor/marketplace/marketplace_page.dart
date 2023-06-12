import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String searchQuery = '';

  void setSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  String formatCurrency(double amount) {
    String formattedValue = 'Rp ' +
        amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard UMKM'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: setSearchQuery,
                        decoration: InputDecoration(
                          labelText: 'Cari Pendanaan',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Perform search logic here
                        // You can use the `searchQuery` variable to access the user's input
                      },
                      child: Text('Cari'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              UMKMCard(
                name: 'UMKM ABC',
                progress: 70,
                totalLoan: 5000000,
                date: 'June 1, 2023',
                creditScore: 750,
                bagiHasil: 8,
              ),
              SizedBox(height: 20.0),
              UMKMCard(
                name: 'UMKM XYZ',
                progress: 50,
                totalLoan: 3000000,
                date: 'June 2, 2023',
                creditScore: 800,
                bagiHasil: 8,
              ),
            ],
          ),
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
        currentIndex: 1, // Set the current index to 1 (Marketplace)
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green[100],
        onTap: (index) {
          if (index == 1) {
            // Do nothing or handle marketplace page logic
          } else {
            // Navigate to the corresponding page based on the selected index
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/beranda');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/portofolio');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profil');
                break;
            }
          }
        },
      ),
    );
  }
}

class UMKMCard extends StatefulWidget {
  final String name;
  final int progress;
  final double totalLoan;
  final String date;
  final int creditScore;
  final int bagiHasil;

  UMKMCard({
    required this.name,
    required this.progress,
    required this.totalLoan,
    required this.date,
    required this.creditScore,
    required this.bagiHasil,
  });

  @override
  _UMKMCardState createState() => _UMKMCardState();
}

class _UMKMCardState extends State<UMKMCard> {
  String formatCurrency(double amount) {
    String formattedValue = 'Rp ' +
        amount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match match) => '${match[1]}.',
            );
    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Credit Score: ${widget.creditScore}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          'Bagi Hasil',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${widget.bagiHasil}%',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Progress:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          child: Stack(
                            children: [
                              CircularProgressIndicator(
                                value: widget.progress / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                                strokeWidth: 6.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Transform.translate(
                                  offset: Offset(0, 2.5),
                                  child: Text(
                                    '${widget.progress}%',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Tanggal Akhir Crowdfunding:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${widget.date}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Total Pinjaman:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  formatCurrency(widget.totalLoan),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
