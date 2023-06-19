import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefs {
  int id_akun = 0;
  int jenis_user = 0;

  Future<void> getId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_akun = prefs.getInt('id_akun') ?? 0;
    jenis_user = prefs.getInt('jenis_user') ?? 0;
    print(prefs.getInt('id_akun'));
    print(prefs.getInt('jenis_user'));

    if (id_akun == 0) {
      goToLoginPage(context);
    }
  }

  void goToLoginPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  //hapus data sharedpref
  Future<void> deleteUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_akun');
    await prefs.remove('jenis_user');
    goToLoginPage(context);
  }
}
