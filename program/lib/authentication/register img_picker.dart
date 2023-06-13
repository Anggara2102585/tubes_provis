import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

enum UserRole {
  Investor,
  Borrower,
}

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Peran'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Investor'),
              onPressed: () {
                Navigator.pushNamed(context, '/register/akun',
                    arguments: UserRole.Investor);
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Peminjam'),
              onPressed: () {
                Navigator.pushNamed(context, '/register/akun',
                    arguments: UserRole.Borrower);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ktpController = TextEditingController();
  TextEditingController selfieController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? ktpPath;
  String? selfiePath;
  TextEditingController businessTypeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  UserRole? selectedRole;
  String? selectedProvince;
  String? selectedCity;

  File? _imagektp;
  File? _imageselfie;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagektp = File(pickedImage.path);
      });
    }
  }

  Future<void> _getImageFromGallery2() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageselfie = File(pickedImage.path);
      });
    }
  }

  Future<void> registerUser() async {
    final String apiUrl = 'http://127.0.0.1:8000/register/pendana';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'ktp': ktpController.text,
        'selfie': selfieController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Registration successful, handle the response
      var responseData = jsonDecode(response.body);
      // Handle the response data as needed
    } else {
      // Registration failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('An error occurred during registration.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    ktpController.dispose();
    selfieController.dispose();
    confirmPasswordController.dispose();
    businessTypeController.dispose();
    addressController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    } else if (value != passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  String? validateKtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'KTP tidak boleh kosong';
    }
    ktpPath = value;
    return null;
  }

  String? validateSelfie(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selfie tidak boleh kosong';
    }
    selfiePath = value;
    return null;
  }

  String? validateBusinessType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jenis usaha tidak boleh kosong';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi usaha tidak boleh kosong';
    }
    return null;
  }

  Future<void> selectKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        ktpPath = result.files.first.path!;
        ktpPath =
            'result.files.first.path!'; // remove this after filepicker is fixed
        ktpController.text = ktpPath!;
      });
    }
  }

  Future<void> selectSelfie() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selfiePath = result.files.first.path!;
        selfiePath =
            'result.files.first.path!'; // remove this after filepicker is fixed
        selfieController.text = selfiePath!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserRole? role =
        ModalRoute.of(context)?.settings.arguments as UserRole?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: validateName,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
                validator: validatePassword,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
                validator: validateConfirmPassword,
              ),
              SizedBox(height: 16.0),
              Row(children: [
                _imagektp != null
                    ?
                    // Web
                    Image.network(
                        _imagektp!.path,
                        height: 50,
                      )
                    : const Text('No image selected'),
              ]),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true, // make it false later
                      controller: ktpController,
                      decoration: InputDecoration(
                        labelText: 'KTP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: validateKtp,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _getImageFromGallery,
                  ),
                ],
              ),
              // ktpPath != null && ktpPath!.isNotEmpty
              //     ? Container(
              //         height: 100,
              //         width: 100,
              //         child: Image.file(
              //           File(ktpPath!),
              //           fit: BoxFit.cover,
              //         ),
              //       )
              //     : SizedBox(),
              SizedBox(height: 16.0),
              Row(children: [
                _imageselfie != null
                    ?
                    // Web
                    Image.network(
                        _imageselfie!.path,
                        height: 50,
                      )
                    : const Text('No image selected'),
              ]),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true, // make it false later
                      controller: selfieController,
                      decoration: InputDecoration(
                        labelText: 'Selfie',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: validateSelfie,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _getImageFromGallery2,
                  ),
                ],
              ),
              // selfiePath != null && selfiePath!.isNotEmpty
              //     ? Container(
              //         height: 100,
              //         width: 100,
              //         child: Image.file(
              //           File(selfiePath!),
              //           fit: BoxFit.cover,
              //         ),
              //       )
              //     : SizedBox(),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lakukan tindakan setelah tombol "Daftar" ditekan
                    // Misalnya, Anda dapat menyimpan data pendaftaran dan melanjutkan ke halaman beranda

                    // Jika role adalah Peminjam (Borrower), tampilkan form tambahan untuk mengisi jenis usaha, alamat, no telepon, dan deskripsi usaha
                    if (role == UserRole.Borrower) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Formulir Peminjam'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Isi formulir tambahan untuk Peminjam'),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: businessTypeController,
                                  decoration: InputDecoration(
                                    labelText: 'Jenis Usaha',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: validateBusinessType,
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Nomor Telepon',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: validatePhone,
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Deskripsi Usaha',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: validateDescription,
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Alamat Usaha',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: validateAddress,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text('Batal'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Daftar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Lakukan tindakan setelah tombol "Daftar" ditekan
                                    // Misalnya, Anda dapat menyimpan data pendaftaran dan melanjutkan ke halaman beranda
                                    // if (photoPath != null) {
                                    //   photoController.text = photoPath!;
                                    // }
                                    Navigator.pushNamed(context, '/');
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Lakukan tindakan setelah tombol "Daftar" ditekan
                      // Misalnya, Anda dapat menyimpan data pendaftaran dan melanjutkan ke halaman beranda
                      registerUser();
                      Navigator.pushNamed(context, '/');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
