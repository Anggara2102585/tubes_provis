import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // void _login(BuildContext context, int id_akun, int jenis_user) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('id_akun', id_akun);
  //   await prefs.setInt('jenis_user', jenis_user);
  //   if (jenis_user == 1) {
  //     Navigator.pushReplacementNamed(context, '/berandaUMKM');
  //   } else {
  //     Navigator.pushReplacementNamed(context, '/beranda');
  //   }
  // }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  Future<Map<String, dynamic>?> _login(
      BuildContext context, String username, String password) async {
    final url =
        'http://127.0.0.1:8000/login'; // Ganti dengan URL API login yang sebenarnya

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Login berhasil
        final data = jsonDecode(response.body);
        final idAkun = data['id_akun'];
        final jenisUser = data['jenis_user'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_akun', idAkun);
        await prefs.setInt('jenis_user', jenisUser);

        return {
          'id_akun': idAkun,
          'jenis_user': jenisUser,
        };
      } else {
        // Handle error saat login (misalnya, tampilkan pesan error)
        return null;
      }
    } catch (e) {
      // Handle exception saat proses login
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: validateUsername,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
                validator: validatePassword,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await _login(context,
                          usernameController.text, passwordController.text);

                      if (response != null) {
                        final idAkun = response['id_akun'];
                        final jenisUser = response['jenis_user'];

                        // Simpan nilai di SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setInt('id_akun', idAkun);
                        await prefs.setInt('jenis_user', jenisUser);

                        // Navigasi ke halaman yang sesuai berdasarkan jenis_user
                        if (jenisUser == 1) {
                          Navigator.pushReplacementNamed(
                              context, '/berandaUMKM');
                        } else {
                          Navigator.pushReplacementNamed(context, '/beranda');
                        }
                      } else {
                        // Handle error saat login (misalnya, tampilkan pesan error)
                      }
                    }
                  }),
              SizedBox(height: 16.0),
              TextButton(
                child: Text(
                  'Belum punya akun? Daftar',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
