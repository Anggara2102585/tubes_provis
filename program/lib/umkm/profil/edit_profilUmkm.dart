import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/profil.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileUmkmPage extends StatefulWidget {
  const EditProfileUmkmPage({Key? key}) : super(key: key);
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfileUmkmPage> {
  bool isEditMode = false;

  late int id_akun;

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

  // late ActivityCubit future
  TextEditingController umkmNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController omsetController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController userusernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // final imageFile = File(pickedImage.path);
      // final appDir = await getApplicationDocumentsDirectory();
      // final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      // final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      setState(() {
        // _image = savedImage;
        _image = File(pickedImage.path);
        // _saveImage();
        // _image
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getId();
    umkmNameController.text = "My Business";
    ownerController.text = "Owner Name";
    omsetController.text = '9.000.000';
    descriptionController.text =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
    typeController.text = 'Usaha Mebel';
    usernameController.text = 'User Name';
    emailController.text = 'user@example.com';
    phoneController.text = '+123456789';
    addressController.text = '123 Street, City';
    userusernameController.text = 'user123';
    passwordController.text = '********';
  }

  @override
  void dispose() {
    // Dispose the text editing controllers
    umkmNameController.dispose();
    ownerController.dispose();
    omsetController.dispose();
    descriptionController.dispose();
    typeController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    userusernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
              // Perform the necessary actions for edit or save
            },
          ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  isEditMode = false;
                  // Reset the form fields with previous values
                  umkmNameController.text = "My Business";
                  ownerController.text = "Owner Name";
                  omsetController.text = '9.000.000';
                  descriptionController.text =
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
                  typeController.text = 'Usaha Mebel';
                  usernameController.text = 'User Name';
                  emailController.text = 'user@example.com';
                  phoneController.text = '+123456789';
                  addressController.text = '123 Street, City';
                  userusernameController.text = 'user123';
                  passwordController.text = '********';
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
                        child: Image.network(
                          _image!.path,
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
                      controller: umkmNameController,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Text(
                    umkmNameController.text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.man),
                    title: const Text('Pemilik Usaha'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: ownerController,
                          )
                        : Text(ownerController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Jenis Usaha'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: typeController,
                          )
                        : Text(typeController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.money),
                    title: const Text('Omset Tahunan'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: omsetController,
                          )
                        : Text("Rp${omsetController.text}"),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: emailController,
                          )
                        : Text(emailController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Telp'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: phoneController,
                          )
                        : Text(phoneController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Alamat'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: addressController,
                          )
                        : Text(addressController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Deskripsi Usaha'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: descriptionController,
                          )
                        : Text(descriptionController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Username'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: userusernameController,
                          )
                        : Text(userusernameController.text),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Password'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: passwordController,
                          )
                        : Text(passwordController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
