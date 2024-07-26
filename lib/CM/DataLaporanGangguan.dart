// // ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// //Menu
// import '../Menu/MenuHome.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPemasangan.dart';
// import '../Menu/MenuPM.dart';
// import '../Menu/Profile.dart';
// import '../user/User.dart';
// import '../CM/EditPage.dart';

// class DataLaporanGangguan extends StatefulWidget {
//   static const String id = "/LaporanGangguanState";
//   const DataLaporanGangguan({Key? key})
//       : super(key: key);
//   @override
//   DataLaporanGangguanState createState() => DataLaporanGangguanState();
// }

// class DataLaporanGangguanState extends State<DataLaporanGangguan> {

//   final List<String> _menuItems = [
//     'Home',
//     'Pemasangan',
//     'Preventive Maintenance',
//     'Corrective Maintenance',
//     'Profile',
//   ];

//   List<Map<String, dynamic>> laporanData = [
//     {
//       'no': 1,
//       'namaAgen': 'Agen 1',
//       'tid': 'TID001',
//       'kanwil': 'Wilayah 1',
//       'tanggalLaporan': DateTime.now(),
//       'status': 'selesai',
//     },
//     {
//       'no': 2,
//       'namaAgen': 'Agen 2',
//       'tid': 'TID002',
//       'kanwil': 'Wilayah 2',
//       'tanggalLaporan': DateTime.now(),
//       'status': 'selesai',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
// // Replace the existing laporanData with the data from the database
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
//       body: ListView(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Data Laporan Gangguan',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columnSpacing: 16.0,
//               columns: const [
//                 DataColumn(label: Text('No')),
//                 DataColumn(label: Text('Nama Agen')),
//                 DataColumn(label: Text('TID')),
//                 DataColumn(label: Text('KanWil')),
//                 DataColumn(label: Text('Tanggal Laporan')),
//                 DataColumn(label: Text('Status')),
//                 DataColumn(label: Text('Aksi')),
//               ],
//               rows: List.generate(
//                 laporanData.length,
//                 (index) => DataRow(
//                   cells: [
//                     DataCell(Text(laporanData[index]['no'].toString())),
//                     DataCell(Text(laporanData[index]['namaAgen'])),
//                     DataCell(Text(laporanData[index]['tid'])),
//                     DataCell(Text(laporanData[index]['kanwil'])),
//                     DataCell(
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 8.0,
//                           ),
//                           Text(
//                             DateFormat('yyyy-MM-dd').format(
//                               laporanData[index]['tanggalLaporan'],
//                             ),
//                           ),
//                           Text(
//                             DateFormat('HH:mm:ss').format(
//                               laporanData[index]['tanggalLaporan'],
//                             ),
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     DataCell(
//                       Container(
//                         height: 28.0,
//                         width: 55.0,
//                         decoration: BoxDecoration(
//                           color: laporanData[index]['status'] == 'selesai'
//                               ? Colors.green
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         padding: const EdgeInsets.all(4),
//                         child: Center(
//                           child: Text(
//                             laporanData[index]['status'],
//                             style: const TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       ElevatedButton(
//                         onPressed: () {
//                           // Aksi ketika tombol Edit/Proses ditekan
//                           if (laporanData[index]['status'] == 'selesai') {
//                             editData(index);
//                           } else {
//                             prosesData(index);
//                           }
//                         },
//                         child: Text(
//                           laporanData[index]['status'] == 'selesai'
//                               ? 'Edit'
//                               : 'Proses',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void editData(int index) {
//     Navigator.push(
//       context as BuildContext,
//       MaterialPageRoute(
//         builder: (context) => EditPage(
//           data: laporanData[index],
//           onSave: (newData) {
//             setState(() {
//               laporanData[index] = newData;
//               laporanData[index]['status'] = 'proses';
//             });
//           },
//         ),
//       ),
//     );
//   }

//   void prosesData(int index) {
//     // Logika untuk menjalankan proses tertentu
//     // Misalnya, mengirim permintaan ke server atau melakukan tugas lainnya

//     setState(() {
//       laporanData[index]['status'] = 'selesai';
//     });

//     // Tampilkan snackbar atau pesan sukses
//     const snackBar = SnackBar(content: Text('Data diproses'));
//     ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
//   }
// }
