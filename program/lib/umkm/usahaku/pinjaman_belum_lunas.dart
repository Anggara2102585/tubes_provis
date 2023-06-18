import 'package:flutter/material.dart';
import 'pendana.dart';

class PinjamanBelumLunas extends StatefulWidget {
  @override
  _PinjamanBelumLunasState createState() => _PinjamanBelumLunasState();
}

class _PinjamanBelumLunasState extends State<PinjamanBelumLunas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int adaBelumLunas = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pinjaman'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Judul Pinjaman',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Deskripsi Pinjaman',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Bagi Hasil',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'XX%',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Bagi Hasil',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Rp XXX',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Rp XXX',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TabBar(
              controller: _tabController,
              indicatorColor: Color.fromARGB(255, 122, 117, 117),
              labelColor: Colors.green,
              unselectedLabelColor: Color.fromARGB(255, 122, 117, 117),
              tabs: [
                Tab(
                  text: 'Tagihan',
                ),
                Tab(
                  text: 'Detail',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTagihanTab(),
                  _buildDetailTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagihanTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (adaBelumLunas == 1)
                Text(
                  'Batas Pinjaman: ',
                  style: TextStyle(fontSize: 12.0),
                )
              else if (adaBelumLunas == 2)
                Text(
                  'Batas Bagi Hasil: ',
                  style: TextStyle(fontSize: 12.0),
                ),
              Text(
                'DD/MM/YYYY', // Replace with actual date
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            'Total Pinjaman: Rp XXX',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Dana Masuk: Rp XXX',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Imba Hasil: Rp XXX',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Jumlah Tagihan: Rp XXX',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to handle payment
                },
                child: Text('Bayar Tagihan'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tanggal Pengajuan: DD/MM/YYYY',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          if (adaBelumLunas == 1)
            Text(
              'Batas Pinjaman: DD/MM/YYYY',
              style: TextStyle(fontSize: 16.0),
            )
          else if (adaBelumLunas == 2)
            Text(
              'Batas Bagi Hasil: DD/MM/YYYY',
              style: TextStyle(fontSize: 16.0),
            ),
          SizedBox(height: 8.0),
          Text(
            'Minimal Pinjaman: Rp XXX',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PendanaPage()),
                );
              },
              child: Text('Lihat Pendana'),
            ),
          ),
        ],
      ),
    );
  }
}
