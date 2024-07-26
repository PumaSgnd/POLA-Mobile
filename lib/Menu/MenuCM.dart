// // ignore_for_file: file_names, library_private_types_in_public_api
// import 'package:flutter/material.dart';
// //Menu CM
// import '../CM/LaporanCM.dart';
// import '../CM/DataLaporanGangguan.dart';
// import '../CM/LaporanGangguan.dart';
// //Menu
// import '../Menu/MenuHome.dart';
// import '../Menu/MenuPemasangan.dart';
// import '../Menu/MenuPM.dart';
// import '../Menu/Profile.dart';
// import '../user/User.dart';

// class MenuCM extends StatefulWidget {
//   static const String id = "/MenuCorrectiveMaintenance";
//   const MenuCM({Key? key}) : super(key: key);
//   @override
//   _MenuCMState createState() => _MenuCMState();
//   static getCount() {}
// }

// class _MenuCMState extends State<MenuCM> {
//   int _selectedIndex = 3;
  
//   final List<String> _menuItems = [
//     'Home',
//     'Job Orders',
//     'Preventive Maintenance',
//     'Corrective Maintenance',
//     'Profile',
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navigasi ke menu yang dipilih
//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MenuHome(),
//           ),
//         );
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MenuPemasangan(),
//           ),
//         );
//         break;
//       case 2:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MenuPM(),
//           ),
//         );
//         break;
//       case 3:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MenuCM(),
//           ),
//         );
//         break;
//       case 4:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Profile(),
//           ),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: false,        
//       ),      
//       body: ListView(
//         padding: const EdgeInsets.all(20.0),
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10.0),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 5.0),
//                 child: Text(
//                   'Menu Corrective Maintenance',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MenuCard(
//                     title: 'Data Laporan Gangguan',
//                     icon: Icons.receipt,
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DataLaporanGangguan(),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(width: 15.0),
//                   MenuCard(
//                     title: 'Input Laporan Gangguan',
//                     icon: Icons.edit,
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               InputLaporanGangguan(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MenuCard(
//                     title: 'Laporan Corrective Maintenance',
//                     icon: Icons.description,
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               LaporanCM(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black, // Warna ikon terpilih
//         unselectedItemColor: Colors.grey, // Warna ikon tidak terpilih
//         items: _menuItems.map((String menuItem) {
//           return BottomNavigationBarItem(
//             icon: Icon(
//               _getIconByMenuItem(menuItem),
//             ),
//             label: menuItem,
//           );
//         }).toList(),
//       ),
//     );
//   }

//   IconData _getIconByMenuItem(String menuItem) {
//     switch (menuItem) {
//       case 'Home':
//         return Icons.home;
//       case 'Job Orders':
//         return Icons.build_rounded;
//       case 'Preventive Maintenance':
//         return Icons.settings;
//       case 'Corrective Maintenance':
//         return Icons.build_circle;
//       case 'Profile':
//         return Icons.person;
//       default:
//         return Icons.home;
//     }
//   }
// }

// class MenuCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Function onTap;

//   const MenuCard({super.key, required this.title, required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Card(
//         elevation: 4.0,
//         child: SizedBox(
//           width: 60.0, // Ubah ukuran lebar Card sesuai kebutuhan
//           height: 80.0, // Ubah ukuran tinggi Card sesuai kebutuhan
//           child: InkWell(
//             onTap: onTap as void Function()?,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(icon, color: Colors.black),
//                   const SizedBox(height: 10.0),
//                   Text(
//                     title,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
