import 'package:flutter/material.dart';
import 'package:myapp/assets/font.dart';
import 'package:myapp/models/profil.dart';
// import 'package:myapp/main.dart' as app;
// import 'package:myapp/models/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';

class ProfilUmkmPage extends StatefulWidget {
  const ProfilUmkmPage({super.key});

  @override
  ProfilPageState createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilUmkmPage> {
  int _selectedIndex = 2;
  var cubit = ActivityCubit();

  //SharedPref
  int id_akun = 0;
  int jenis_user = 0;

  @override
  void initState() {
    super.initState();
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
        Navigator.pushNamed(context, '/berandaUMKM');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/usahaku');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profilUmkm');
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
        child: _ProfilUmkmContent(),
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

class _ProfilUmkmContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: _ProfileCard(
              profileImage: 'https://placehold.co/400x400.png',
              userName: 'John Doe',
            ),
          ),
          ListTile(
            title: const Text('Profil Usaha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profilUmkm');
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
            const SizedBox(height: 8.0),
            const Text("Pemilik UMKM")
          ],
        ),
      ),
    );
  }
}
