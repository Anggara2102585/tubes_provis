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
  late Future<int> id_akun;

  // Ambil dari shared preferences
  // Return id_akun
  Future<int> ambilDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_akun') ?? 0;
  }

  // Simpan ke shared preferences
  Future<void> simpanDataUser(int id_akun) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_akun', id_akun);
  }

  // Hapus data dari shared preferences
  Future<void> hapusDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_akun');
  }

  @override
  void initState() {
    super.initState();
    id_akun = ambilDataUser();
  }

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

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url =
        'http://127.0.0.1:8000/login'; // Replace with your actual login API URL

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
        // Successful login
        final data = jsonDecode(response.body);
        return {
          'id_akun': data['id_akun'],
          'jenis_user': data['jenis_user'],
        };
      } else {
        // Handle login error (e.g., display an error message)
        return null;
      }
    } catch (e) {
      // Handle any exceptions during the login process
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
        child: FutureBuilder<int>(
            future: id_akun,
            builder: (context, snapshot) {
              return Form(
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
                          // Perform login API call and retrieve the response
                          final response = await login(
                              usernameController.text, passwordController.text);

                          if (response != null) {
                            // setState(() {
                            //   //set userid (simulasi)
                            //   //simpan ke sharedpref
                            //   //sekaligus refresh
                            //   simpanDataUser(response['id_akun']);
                            //   id_akun = ambilDataUser();
                            // });
                            // Store the login result in shared preferences
                            await simpanDataUser(response['id_akun']);

                            if (response['jenis_user'] == 2) {
                              Navigator.pushNamed(
                                context,
                                '/beranda',
                                arguments: snapshot.data!,
                              );
                            } else if (response['jenis_user'] == 1) {
                              Navigator.pushNamed(
                                context,
                                '/berandaUMKM',
                                arguments: snapshot.data!,
                              );
                            }
                          } else {
                            // Handle login error (e.g., display an error message)
                          }
                        }
                      },
                    ),
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
              );
            }),
      ),
    );
  }
}
