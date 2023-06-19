import 'package:flutter/material.dart';
import 'package:myapp/assets/font.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';

enum MetodePusatBantuan { transferBank, eWallet }

class PusatBantuanPage extends StatefulWidget {
  const PusatBantuanPage({Key? key}) : super(key: key);

  @override
  PusatBantuanPageState createState() => PusatBantuanPageState();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beranda',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PusatBantuanPage(),
    );
  }
}

class PusatBantuanPageState extends State<PusatBantuanPage> {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Pusat Bantuan',
                  style: titleTextStyle,
                ),
                // backgroundColor: Colors.green,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Customer Service'),
                    Tab(text: 'Panduan & Tutorial'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _CustomerService(),
                  ),
                  _PanduanTutorial(),
                ],
              )),
        ),
      ),
    );
  }
}

class _CustomerService extends StatelessWidget {
  final List<Map<String, dynamic>> contacts = [
    {
      'name': 'Instagram',
      'account': '@example',
      'icon': Icons.question_mark_rounded,
    },
    {
      'name': 'Telepon',
      'account': '+123456789',
      'icon': Icons.phone,
    },
    {
      'name': 'Email',
      'account': 'example@example.com',
      'icon': Icons.email,
    },
    // Add more contacts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: Icon(contact['icon']),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact['name'],
                style: const TextStyle(color: Colors.grey),
              ),
              Text(contact['account']),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Handle item click here
            // Example: Open social media app or call app
            if (contact['name'] == 'Instagram') {
              // Open Instagram
            } else if (contact['name'] == 'Telephone') {
              // Make a phone call
            } else if (contact['name'] == 'Email') {
              // Compose an email
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}

class _PanduanTutorial extends StatelessWidget {
  final List<Map<String, dynamic>> videos = [
    {
      'thumbnail': 'https://placehold.co/600x400/png',
      'title': 'Video 1',
    },
    {
      'thumbnail': 'https://placehold.co/600x400/png',
      'title': 'Video 2',
    },
    // Add more videos as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video['thumbnail'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      video['title'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            // Handle video item click here
            // Example: Open video player screen
          },
        );
      },
    );
  }
}
