import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart' as crop;
import 'package:image_picker_web/image_picker_web.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditMode = false;
  Uint8List? _selectedImage;
  final ImagePickerWeb _imagePicker = ImagePickerWeb();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _selectProfilePicture() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoad.listen((e) {
          final imageBytes = reader.result as Uint8List;
          setState(() {
            _selectedImage = imageBytes;
          });
        });

        reader.readAsArrayBuffer(file);
      }
    });
  }

  // Future<Uint8List?> _cropImage(Uint8List? imageData) async {
  //   if (imageData == null) return null;

  //   final cropKey = GlobalKey<crop.ImageCropState>();
  //   final aspectRatio = CropAspectRatio(aspectRatioX: 1, aspectRatioY: 1);
  //   final croppedImage = await showDialog<Uint8List>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Crop Image'),
  //         content: crop.ImageCrop(
  //           key: cropKey,
  //           image: imageData,
  //           aspectRatio: aspectRatio,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(cropKey.currentState?.crop());
  //             },
  //             child: const Text('Crop'),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   return croppedImage;
  // }

  @override
  void initState() {
    super.initState();
    // Initialize the text field values with previous data
    nameController.text = 'User Name';
    emailController.text = 'user@example.com';
    phoneController.text = '+123456789';
    addressController.text = '123 Street, City';
    usernameController.text = 'user123';
    passwordController.text = '********';
  }

  @override
  void dispose() {
    // Dispose the text editing controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
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
                  nameController.text = 'User Name';
                  emailController.text = 'user@example.com';
                  phoneController.text = '+123456789';
                  addressController.text = '123 Street, City';
                  usernameController.text = 'user123';
                  passwordController.text = '********';
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectProfilePicture,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                // child: CircleAvatar(
                //   radius: 80,
                //   backgroundImage: _selectedImage != null
                //       ? MemoryImage(_selectedImage!)
                //       : const NetworkImage('https://placehold.co/400x400.png'),
                // ),
              ),
            ),
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
                : Text(
                    nameController.text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
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
                    leading: const Icon(Icons.person),
                    title: const Text('Username'),
                    subtitle: isEditMode
                        ? TextField(
                            controller: usernameController,
                          )
                        : Text(usernameController.text),
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
