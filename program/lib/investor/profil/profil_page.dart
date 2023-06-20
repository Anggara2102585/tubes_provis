import 'package:flutter/material.dart';
import 'package:myapp/assets/font.dart';
import 'package:myapp/models/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  ProfilPageState createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  int _selectedIndex = 3; // Set default selected index to 1 (Profil)
  var f = ActivityCubit();
  late Map<dynamic, dynamic>? _data = {
    'nama_pendana': '',
  };

  //SharedPref
  int id_akun = 0;
  int jenis_user = 0;

  @override
  void initState() {
    super.initState();
    fetchDataOnce();
    _initIdAkun();
  }

  Future<void> _initIdAkun() async {
    MySharedPrefs sharedPrefs = MySharedPrefs();
    await sharedPrefs.getId(context);
    setState(() {
      id_akun = sharedPrefs.id_akun;
      jenis_user = sharedPrefs.jenis_user;
    });
  }

  Future<void> fetchDataOnce() async {
    final String apiUrl = 'http://127.0.0.1:8000/pendana/beranda';
    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_akun': id_akun}),
    );
    // Assuming the data fetched from the API is in the following format

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Fetch data successful, handle the response
      setState(() {
        _data = responseData; // Store the fetched data in the variable
      });
      // _data = responseData;
    } else {
      // Registration failed, throw an exception or return an empty map
      throw Exception('An error occurred during registration.');
    }
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
        child: _ProfilPageContent(data: _data),
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
  final Map<dynamic, dynamic>? data; // Declare data as a parameter

  const _ProfilPageContent({this.data}); // Accept data as a parameter

  @override
  Widget build(BuildContext context) {
    final String userName = data?['nama_pendana'] ?? '';
    return Center(
      child: Column(
        children: [
          // SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity, // Set the container width to fit the screen
            child: _ProfileCard(
              profileImage: 'https://placehold.co/400x400.png',
              userName: userName,
            ),
          ),
          ListTile(
            title: Text('Akun'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profil');
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
            trailing: const Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () {
              // Handle 'Keluar' button tap
              // Perform logout action
              MySharedPrefs sharedPrefs = MySharedPrefs();
              sharedPrefs.deleteUser(context);
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
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
