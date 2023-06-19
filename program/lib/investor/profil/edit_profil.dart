import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:image_crop/image_crop.dart' as crop;
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/profil.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_pref.dart';

// class ProfilPendanaModel {
//   String? foto_profil;
//   String? nama_pendana;
//   String? email;
//   String? telp;
//   String? alamat;
//   String? username;
//   String? password;

//   ProfilPendanaModel();

//   void setProperties(
//     String foto_profil,
//     String nama_pendana,
//     String email,
//     String telp,
//     String alamat,
//     String username,
//     String password
//   )
//   {
//     this.foto_profil = foto_profil;
//     this.nama_pendana = nama_pendana;
//     this.email = email;
//     this.telp = telp;
//     this.alamat = alamat;
//     this.username = username;
//     this.password = password;
//   }
// }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditMode = false;
  Uint8List? _selectedImage;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController usernameController;
  // late TextEditingController passwordController;

  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  //SharedPref
  int id_akun = 0;
  int jenis_user = 0;

  Future<void> _initIdAkun() async {
    MySharedPrefs sharedPrefs = MySharedPrefs();
    await sharedPrefs.getId(context);
    setState(() {
      id_akun = sharedPrefs.id_akun;
      jenis_user = sharedPrefs.jenis_user;
    });
  }

  Future<Map<String, String>> fetchData() async {
    // Fetch data from API and return as a map
    final String apiUrl = 'http://127.0.0.1:8000/profil_pendana';
    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_akun': id_akun}),
    );
    // Assuming the data fetched from the API is in the following format
    final responseData = jsonDecode(response.body);
    final Map<String, String> data = {
      'nama_pendana': responseData['nama_pendana'] ?? '',
      'email': responseData['email'] ?? '',
      'telp': responseData['telp'] ?? '123',
      'alamat': responseData['alamat'] ?? '',
      'username': responseData['username'] ?? '',
      // 'password': responseData['password'] ?? '',
    };
    if (response.statusCode == 200) {
      // Fetch data successful, handle the response
    } else {
      // Registration failed, throw an exception or return an empty map
      throw Exception('An error occurred during registration.');
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  isEditMode = false;
                  fetchData().then((responseData) {
                    nameController.text = responseData['nama_pendana'] ?? '';
                    emailController.text = responseData['email'] ?? '';
                    phoneController.text = responseData['telp'] ?? '';
                    addressController.text = responseData['alamat'] ?? '';
                    usernameController.text = responseData['username'] ?? '';
                    // passwordController.text = responseData['password'] ?? '';
                  });
                  _image = null;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: CircleAvatar(
                radius: 50,
                child: _image == null
                    ? Icon(Icons.person)
                    : ClipOval(
                        child: Image.file(
                          _image!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            isEditMode
                ? ElevatedButton(
                    onPressed: _getImageFromGallery,
                    child: const Text('Select Image'),
                  )
                : const SizedBox(height: 0),
            const SizedBox(height: 10),
            isEditMode
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: nameController,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : FutureBuilder<Map<String, String>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final responseData = snapshot.data!;
                        nameController = TextEditingController(
                          text: responseData['nama_pendana'] ?? '',
                        );
                        return Text(
                          nameController.text,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: emailController,
                          )
                        : FutureBuilder<Map<String, String>>(
                            future: fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final responseData = snapshot.data!;
                                emailController = TextEditingController(
                                  text: responseData['email'] ?? '',
                                );

                                return Text(emailController.text);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Telp'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: phoneController,
                          )
                        : FutureBuilder<Map<String, String>>(
                            future: fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final responseData = snapshot.data!;
                                phoneController = TextEditingController(
                                  text: responseData['telp'] ?? '',
                                );

                                return Text(phoneController.text);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Alamat'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: addressController,
                          )
                        : FutureBuilder<Map<String, String>>(
                            future: fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final responseData = snapshot.data!;
                                addressController = TextEditingController(
                                  text: responseData['alamat'] ?? '',
                                );

                                return Text(addressController.text);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Username'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: usernameController,
                          )
                        : FutureBuilder<Map<String, String>>(
                            future: fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final responseData = snapshot.data!;
                                usernameController = TextEditingController(
                                  text: responseData['username'] ?? '',
                                );

                                return Text(usernameController.text);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                  const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.lock),
                  //   title: const Text('Password'),
                  //   subtitle: isEditMode
                  //       ? TextField(
                  //           controller: passwordController,
                  //         )
                  //       : FutureBuilder<Map<String, String>>(
                  //           future: fetchData(),
                  //           builder: (context, snapshot) {
                  //             if (snapshot.hasData) {
                  //               final responseData = snapshot.data!;
                  //               passwordController = TextEditingController(
                  //                 text: responseData['password'] ?? '',
                  //               );

                  //               return Text(passwordController.text);
                  //             } else if (snapshot.hasError) {
                  //               return Text('Error: ${snapshot.error}');
                  //             } else {
                  //               return CircularProgressIndicator();
                  //             }
                  //           },
                  //         ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
