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

  Future<void> fetchData() async {
    final String apiUrl = 'http://127.0.0.1:8000/profil_pendana';
    
    await _initIdAkun();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_akun': id_akun}),
    );

    if (response.statusCode == 200) {
      // Fetch data successful, handle the response
      final responseData = jsonDecode(response.body);
      nameController.text = responseData['nama_pendana'] ?? '';
      emailController.text = responseData['email'] ?? '';
      phoneController.text = responseData['telp'] ?? '';
      addressController.text = responseData['alamat'] ?? '';
      usernameController.text = responseData['username'] ?? '';
      passwordController.text = responseData['password'] ?? '';
    } else {
      // Registration failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Fetch Data Failed'),
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


  // final ImagePickerWeb _imagePicker = ImagePickerWeb();
  // final models = ActivityCubit();
  // var futureProfil = ActivityCubit.fetchData();
  late ActivityProfil futureProfil;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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

  Future<void> _saveImage() async {
    if (_image != null) {
      try {
        // Get the application documents directory

        final directory = await getApplicationDocumentsDirectory();

        // Generate a unique filename for the image
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        // final fileName = _image!.path;
        final fileName = 'image_$timestamp.jpg';

        // Check if the directory exists, create it if necessary
        if (!(await directory.exists())) {
          await directory.create(recursive: true);
        }
        // Create the destination file path
        final destinationPath = '${directory.path}/$fileName';

        // Copy the image file to the destination path
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(destinationPath)),
        );
        await _image!.copy(destinationPath);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved successfully!')),
        );
      } catch (e) {
        // Show an error message if the image saving fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image!')),
        );
        print(e);
      }
    } else {
      // Show a message if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // _initIdAkun(); // dipanggil di fetchData()
    // futureProfil = models.fetchData() as ActivityProfil;
    // Initialize the text field values with previous data
    nameController.text = 'User Name';
    emailController.text = 'user@example.com';
    phoneController.text = '+123456789';
    addressController.text = '123 Street, City';
    usernameController.text = 'user123';
    // passwordController.text = '********';

    fetchData();
  }

  @override
  void dispose() {
    // Dispose the text editing controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    // passwordController.dispose();
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
                  // passwordController.text = '********';
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
            // ElevatedButton(onPressed: _saveImage, child: const Text('Save')),
            // const SizedBox(height: 20),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(color: Theme.of(context).primaryColor),
            //     ),
            //     // child: CircleAvatar(
            //     //   radius: 80,
            //     //   backgroundImage: _selectedImage != null
            //     //       ? MemoryImage(_selectedImage!)
            //     //       : const NetworkImage('https://placehold.co/400x400.png'),
            //     // ),
            //   ),
            // ),
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
                  // const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.lock),
                  //   title: const Text('Password'),
                  //   subtitle: isEditMode
                  //       ? TextField(
                  //           controller: passwordController,
                  //         )
                  //       : Text(passwordController.text),
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
