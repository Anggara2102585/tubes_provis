import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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

  final List<NotificationItem> notifications = [
    NotificationItem(
      subject: 'Pemberitahuan Penting',
      body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      dateTime: DateTime(2023, 5, 19, 9, 30),
    ),
    NotificationItem(
      subject: 'Promo Spesial',
      body: 'Aenean eu sem vitae ex semper dictum vitae ut lectus.',
      dateTime: DateTime(2023, 5, 18, 15, 45),
    ),
    NotificationItem(
      subject: 'Info Terbaru',
      body: 'Fusce consectetur metus sed posuere facilisis.',
      dateTime: DateTime(2023, 5, 17, 10, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi, $id_akun'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(notifications[index].subject),
            subtitle: Text(notifications[index].body),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${notifications[index].dateTime.day}/${notifications[index].dateTime.month}/${notifications[index].dateTime.year}',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '${notifications[index].dateTime.hour}:${notifications[index].dateTime.minute}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String subject;
  final String body;
  final DateTime dateTime;

  NotificationItem({
    required this.subject,
    required this.body,
    required this.dateTime,
  });
}
