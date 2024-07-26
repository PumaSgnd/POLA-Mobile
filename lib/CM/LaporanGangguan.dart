// // ignore_for_file: file_names, library_private_types_in_public_api
// import 'package:flutter/material.dart';
// //Menu
// import '../Menu/MenuHome.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPemasangan.dart';
// import '../Menu/MenuPM.dart';
// import '../Menu/Profile.dart';
// import '../user/User.dart';

// class InputLaporanGangguan extends StatefulWidget {
//   static const String id = "/InputLaporanGangguan";
//   const InputLaporanGangguan({Key? key}) : super(key: key);
//   @override
//   _InputLaporanGangguanState createState() => _InputLaporanGangguanState();
// }

// class _InputLaporanGangguanState extends State<InputLaporanGangguan> {

//   final List<String> _menuItems = [
//     'Home',
//     'Pemasangan',
//     'Preventive Maintenance',
//     'Corrective Maintenance',
//     'Profile',
//   ];

//   String? serialNumber;
//   String? tid;
//   String? namaAgen;
//   String? kanwil;
//   String? catatanGangguan;
//   String? teleponAgen;
//   String selectedCountryCode = '+62';

//   @override
//   void initState() {
//     super.initState();
//     // Fetch initial data based on serial number
//     getInitialData();
//   }

//   void getInitialData() {
//     // Fetch data from the database based on the serial number
//     serialNumber = ' ';
//     tid = getTidFromDatabase(serialNumber);
//     namaAgen = getNamaAgenFromDatabase(serialNumber);
//     kanwil = getKanwilFromDatabase(serialNumber);
//     teleponAgen = getTeleponAgenFromDatabase(serialNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MenuCM(),
//               ),
//             ); // Navigate back when the button is pressed
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Input Corrective Maintenance',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Serial Number *'),
//                 onChanged: (value) {
//                   setState(() {
//                     serialNumber = value;
//                     // Fetch updated data based on the new serial number
//                     tid = getTidFromDatabase(serialNumber);
//                     namaAgen = getNamaAgenFromDatabase(serialNumber);
//                     kanwil = getKanwilFromDatabase(serialNumber);
//                     teleponAgen = getTeleponAgenFromDatabase(serialNumber);
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'TID'),
//                 enabled: false,
//                 initialValue: tid,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Nama Agen'),
//                 enabled: false,
//                 initialValue: namaAgen,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Kanwil'),
//                 enabled: false,
//                 initialValue: kanwil,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Catatan Gangguan'),
//                 onChanged: (value) {
//                   setState(() {
//                     catatanGangguan = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 12.0),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedCountryCode,
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedCountryCode = newValue!;
//                         });
//                       },
//                       items: const [
//                         DropdownMenuItem(
//                           value: '+62',
//                           child: Text('+62'),
//                         ),
//                         DropdownMenuItem(
//                           value: '+1',
//                           child: Text('+1'),
//                         ),
//                         DropdownMenuItem(
//                           value: '+44',
//                           child: Text('+44'),
//                         ),
//                         DropdownMenuItem(
//                           value: '+51',
//                           child: Text('+51'),
//                         ),
//                         // Add more country code options as needed
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 4,
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Telepon Agen',
//                       ),
//                       initialValue: teleponAgen,
//                       enabled: false,
//                       onChanged: (value) {
//                         setState(() {
//                           teleponAgen = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10.0),
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.blue),
//                   minimumSize: MaterialStateProperty.all<Size>(
//                       const Size(120, 50)), // Mengubah ukuran tombol
//                 ),
//                 onPressed: () {
//                   // Simpan data ke database atau lakukan operasi lainnya
//                   _showConfirmationDialog();
//                 },
//                 child: const Text(
//                   'Simpan',
//                   style: TextStyle(color: Colors.white, fontSize: 15.0),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getIconByMenuItem(String menuItem) {
//     switch (menuItem) {
//       case 'Home':
//         return Icons.home;
//       case 'Pemasangan':
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

//   String? getTidFromDatabase(String? serialNumber) {
//     // Kode untuk mengambil TID dari database berdasarkan Serial Number
//     return '';
//   }

//   String? getNamaAgenFromDatabase(String? serialNumber) {
//     // Kode untuk mengambil Nama Agen dari database berdasarkan Serial Number
//     return '';
//   }

//   String? getKanwilFromDatabase(String? serialNumber) {
//     // Kode untuk mengambil Kanwil dari database berdasarkan Serial Number
//     return '';
//   }

//   String? getTeleponAgenFromDatabase(String? serialNumber) {
//     // Kode untuk mengambil Telepon Agen dari database berdasarkan Serial Number
//     return '';
//   }

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Konfirmasi'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Serial Number: $serialNumber'),
//               Text('TID: $tid'),
//               Text('Nama Agen: $namaAgen'),
//               Text('Kanwil: $kanwil'),
//               Text('Catatan Gangguan: $catatanGangguan'),
//               Text('Telepon Agen: $selectedCountryCode $teleponAgen'),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 // Lakukan operasi simpan data ke database atau tindakan lainnya
//                 Navigator.pop(
//                     context); // Tutup dialog setelah tombol "Simpan" pada pop-up diklik
//               },
//               child: const Text('Simpan'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                     context); // Tutup dialog saat tombol "Batal" pada pop-up diklik
//               },
//               child: const Text('Batal'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
