import 'package:flutter/material.dart';

class PendanaPage extends StatefulWidget {
  @override
  _PendanaPageState createState() => _PendanaPageState();
}

class _PendanaPageState extends State<PendanaPage> {
  List<Map<String, dynamic>> _pendanaList = [
    {
      'pendana': 'Pendana 1',
      'nama': 'Tatang',
      'jumlah': 'Rp 100.000',
      'tanggal': '01/01/2023',
    },
    {
      'pendana': 'Pendana 2',
      'nama': 'Lintang',
      'jumlah': 'Rp 200.000',
      'tanggal': '02/02/2023',
    },
    {
      'pendana': 'Pendana 3',
      'nama': 'Dwi',
      'jumlah': 'Rp 300.000',
      'tanggal': '03/03/2023',
    },
  ];

  String? _selectedPendana;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendana'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pendana UMKM',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _pendanaList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pendanaList[index]['pendana']),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(_pendanaList[index]['pendana']),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Nama Pendana: ${_pendanaList[index]['nama']}'),
                              SizedBox(height: 8.0),
                              Text(
                                  'Jumlah Pendanaan: ${_pendanaList[index]['jumlah']}'),
                              SizedBox(height: 8.0),
                              Text(
                                  'Tanggal Pemberian Dana: ${_pendanaList[index]['tanggal']}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Kembali'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
