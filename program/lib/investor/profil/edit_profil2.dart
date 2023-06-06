
// import 'package:flutter/material.dart';
// import 'package:myapp/assets/font.dart';

// class EditProfil extends StatefulWidget {
//   @override
//   _EditProfilState createState() => _EditProfilState();
// }

// class _EditProfilState extends State<EditProfil> {
//   int _selectedIndex = 3; // Set default selected index to 1 (Profil)

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) {
//       // Kembali ke halaman sebelumnya
//       Navigator.pop(context);
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }

//     // Navigate to the corresponding page based on the selected index
//     switch (_selectedIndex) {
//       case 0:
//         Navigator.pushReplacementNamed(context,
//             '/'); // Use pushReplacementNamed to replace the current page
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/marketplace');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/portofolio');
//         break;
//       case 3:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profil',
//           style: titleTextStyle,
//         ),
//       ),
//       body: Center(
//         child: _FormEditCard(
//             userName: 'John Doe',
//             userPhone: '081221',
//             userEmail: 'john@mail.com'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Beranda',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Marketplace',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.pie_chart),
//             label: 'Portofolio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.green[100],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class EditProfilPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(
//             width: double.infinity,
//             child: CircleAvatar(
//               backgroundImage: AssetImage('../assets/user.jpg'),
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: _FormEditCard(
//                 userName: 'John Doe',
//                 userPhone: '081221',
//                 userEmail: 'john@mail.com'),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _FormEditCard extends StatelessWidget {
//   final String userName;
//   final String userPhone;
//   final String userEmail;

//   const _FormEditCard({
//     required this.userName,
//     required this.userPhone,
//     required this.userEmail,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Theme.of(context).primaryColor),
//               ),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration:
//                         InputDecoration(labelText: 'Nama', hintText: userName),
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                         labelText: 'No Telepon', hintText: userPhone),
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                         labelText: 'Email', hintText: userEmail),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
