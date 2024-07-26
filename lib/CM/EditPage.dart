// // ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// //Menu
// import '../Menu/MenuHome.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPemasangan.dart';
// import '../Menu/MenuPM.dart';
// import '../Menu/Profile.dart';
// import '../user/User.dart';
// import '../CM/DataLaporanGangguan.dart';

// class EditPage extends StatefulWidget {
//   static const String id = "/EditPage";
//   final Map<String, dynamic> data;
//   final Function(Map<String, dynamic>) onSave;
//   const EditPage({required this.data, required this.onSave, Key? key}): super(key: key);

//   @override
//   _EditPageState createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   int _selectedIndex = 3;

//   final List<String> _menuItems = [
//     'Home',
//     'Pemasangan',
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
//             builder: (context) => MenuHome(userData: null,),
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

//   final TextEditingController _noController = TextEditingController();
//   final TextEditingController _namaAgenController = TextEditingController();
//   final TextEditingController _tidController = TextEditingController();
//   final TextEditingController _kanwilController = TextEditingController();
//   DateTime _selectedDateTime = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _noController.text = widget.data['no'].toString();
//     _namaAgenController.text = widget.data['namaAgen'];
//     _tidController.text = widget.data['tid'];
//     _kanwilController.text = widget.data['kanwil'];
//     _selectedDateTime = widget.data['tanggalLaporan'];
//   }

//   @override
//   void dispose() {
//     _noController.dispose();
//     _namaAgenController.dispose();
//     _tidController.dispose();
//     _kanwilController.dispose();
//     super.dispose();
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
//                 builder: (context) => DataLaporanGangguan(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: ListView(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Edit Laporan',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _noController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: 'No',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _namaAgenController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nama Agen',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _tidController,
//                   decoration: const InputDecoration(
//                     labelText: 'TID',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _kanwilController,
//                   decoration: const InputDecoration(
//                     labelText: 'KanWil',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () {
//                     _selectDateTime(context);
//                   },
//                   child: AbsorbPointer(
//                     child: TextField(
//                       controller: TextEditingController(
//                         text: DateFormat('yyyy-MM-dd HH:mm:ss')
//                             .format(_selectedDateTime),
//                       ),
//                       decoration: const InputDecoration(
//                         labelText: 'Tanggal Laporan',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Simpan perubahan dan kembali ke halaman sebelumnya
//                     saveChanges();
//                   },
//                   child: const Text('Simpan Perubahan'),
//                 ),
//               ],
//             ),
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
//       case 'Pemasangan':
//         return Icons.build_rounded;
//       case 'Preventive Maintenance':
//         return Icons.warning;
//       case 'Corrective Maintenance':
//         return Icons.build_circle;
//       case 'Profile':
//         return Icons.person;
//       default:
//         return Icons.home;
//     }
//   }

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           _selectedDateTime = DateTime(
//             picked.year,
//             picked.month,
//             picked.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }

//   void saveChanges() {
//     int no = int.parse(_noController.text);
//     String namaAgen = _namaAgenController.text;
//     String tid = _tidController.text;
//     String kanwil = _kanwilController.text;

//     // Lakukan logika penyimpanan perubahan data sesuai dengan kebutuhan Anda
//     // Misalnya, menyimpan perubahan ke server atau menyimpan ke penyimpanan lokal

//     Map<String, dynamic> newData = {
//       'no': no,
//       'namaAgen': namaAgen,
//       'tid': tid,
//       'kanwil': kanwil,
//       'tanggalLaporan': _selectedDateTime,
//     };

//     // Panggil fungsi onSave yang diberikan melalui konstruktor
//     widget.onSave(newData);

//     // Tampilkan snackbar atau pesan sukses
//     const snackBar = SnackBar(content: Text('Perubahan disimpan'));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);

//     // Kembali ke halaman sebelumnya
//     Navigator.pop(context);
//   }
// }
