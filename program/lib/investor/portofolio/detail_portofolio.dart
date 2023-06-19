import 'package:flutter/material.dart';
import 'portofolio_page.dart';
import '../../assets/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPortofolioPage extends StatefulWidget {
  const DetailPortofolioPage({Key? key}) : super(key: key);
  @override
  _DetailPortofolioPageState createState() => _DetailPortofolioPageState();
}

class _DetailPortofolioPageState extends State<DetailPortofolioPage> {
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

  @override
  Widget build(BuildContext context) {
    // final Portofolio portofolio =
    //     ModalRoute.of(context)!.settings.arguments as Portofolio;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendanaan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/portofolio',
      routes: {
        '/portofolio': (context) => PortofolioPage(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pendanaan',
            style: titleTextStyle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Tambahkan ikon panah kembali
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Navigasikan kembali ke halaman sebelumnya
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            // Replace with your profile image
                            // backgroundImage: AssetImage('your_image_path'),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Pemilik UMKM',
                                style: body2BoldTextStyle,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'UMKM Name',
                                style: body2TextStyle,
                              ),
                              Text(
                                'Jenis Usaha',
                                style: body2TextStyle,
                              ),
                              Text(
                                '082xxxxxxxx',
                                style: body2TextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'UMKM Details:',
                        style: body2BoldTextStyle,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in pulvinar magna, at posuere felis. Nunc non finibus ante, vel blandit mauris.',
                        style: body2TextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Pendanaan',
                        style: body2BoldTextStyle,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in pulvinar magna, at posuere felis. Nunc non finibus ante, vel blandit mauris.',
                        style: body2TextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProgressBar(
                        value: 0.2,
                        label: '20%',
                        progressNumber: 'Progres 1',
                        progressColor: Colors.green,
                      ),
                      ProgressBar(
                        value: 0.4,
                        label: '40%',
                        progressNumber: 'Progres 2',
                        progressColor: Colors.green,
                      ),
                      ProgressBar(
                        value: 0.6,
                        label: '60%',
                        progressNumber: 'Progres 3',
                        progressColor: Colors.green,
                      ),
                      ProgressBar(
                        value: 0.8,
                        label: '80%',
                        progressNumber: 'Progres 4',
                        progressColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ulasan',
                        style: body2BoldTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in pulvinar magna, at posuere felis. Nunc non finibus ante, vel blandit mauris.',
                        style: body2TextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double value;
  final String label;
  final String progressNumber;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const ProgressBar({
    required this.value,
    required this.label,
    required this.progressNumber,
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 4.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeWidth: strokeWidth,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progressNumber,
                style: captionTextStyle,
              ),
              Text(
                label,
                style: captionTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
