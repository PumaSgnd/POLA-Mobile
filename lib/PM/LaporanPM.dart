// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// //Menu
// import '../Menu/MenuPM.dart';
// import '../PM/LaporanPMDetail.dart';

// class LaporanPM extends StatefulWidget {
//   static const String id = "/LaporanPM";
//   const LaporanPM({Key? key}) : super(key: key);
//   @override
//   _LaporanPMState createState() => _LaporanPMState();
// }

// class _LaporanPMState extends State<LaporanPM> {
//   final TextEditingController filterSearchController = TextEditingController();
//   String filterKanwil = 'Kanwil (Semua)';
//   String filterKota = 'Kota (Semua)';
//   String searchText = '';
//   DateTime? minDate;
//   DateTime? maxDate;

//   List<Map<String, String>> dataList = [
//     {
//       'nomor_jo': 'JO123',
//       'nama_agen': 'Agen 1',
//       'kota': 'Kota 1',
//       'id_kanwil': 'Kanwil 1',
//       'jadwal_pm': '01/02/2023',
//       'tanggal_proses_pm': '01/01/2023',
//       'tanggal_visited': '01/01/2023',
//     },
//     {
//       'nomor_jo': 'JO124',
//       'nama_agen': 'Agen 2',
//       'kota': 'Kota 2',
//       'id_kanwil': 'Kanwil 2',
//       'jadwal_pm': '02/02/2023',
//       'tanggal_proses_pm': '02/01/2023',
//       'tanggal_visited': '02/01/2023',
//     },
//   ];

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
//                 builder: (context) => const MenuPM(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(30.0),
//               child: Text(
//                 'Laporan Preventive Maintenance',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 30.0),
//                     child: Container(
//                       width: 100.0,
//                       height: 40.0,
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           labelText: 'Cari',
//                           border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(8.0)),
//                           ),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             searchText = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: 30.0), // Add left padding here
//                   child: Container(
//                     width: 100.0,
//                     height: 40.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Tambahkan logika untuk ekspor data di sini
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       child: const Text('Export',
//                           style: TextStyle(fontSize: 14.0)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 30.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: DropdownButton<String>(
//                           value: filterKanwil,
//                           onChanged: (value) {
//                             setState(() {
//                               filterKanwil = value!;
//                             });
//                           },
//                           items: <String>[
//                             'Kanwil (Semua)',
//                             'Kanwil 1',
//                             'Kanwil 2',
//                           ].map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8.0,
//                                   bottom: 3.0,
//                                 ),
//                                 child: Text(
//                                   value,
//                                   style: const TextStyle(
//                                     fontSize: 14.0,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           hint: const Padding(
//                             padding: EdgeInsets.only(left: 10.0),
//                             child: Text(
//                               'Kanwil (Semua)',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                           ),
//                           isExpanded: true,
//                           underline: Container(),
//                           itemHeight: kMinInteractiveDimension,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: DropdownButton<String>(
//                           value: filterKota,
//                           onChanged: (value) {
//                             setState(() {
//                               filterKota = value!;
//                             });
//                           },
//                           items: <String>[
//                             'Kota (Semua)',
//                             'Kota 1',
//                             'Kota 2',
//                           ].map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8.0,
//                                   bottom: 3.0,
//                                 ),
//                                 child: Text(
//                                   value,
//                                   style: const TextStyle(
//                                     fontSize: 14.0,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           hint: const Padding(
//                             padding: EdgeInsets.only(left: 10.0),
//                             child: Text(
//                               'Kota (Semua)',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                           ),
//                           isExpanded: true,
//                           underline: Container(),
//                           itemHeight: kMinInteractiveDimension,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SingleChildScrollView(
//               padding: const EdgeInsets.only(left: 30.0),
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 20, // Menambahkan jarak antar kolom
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: Colors.grey), // Warna dan ketebalan border
//                   borderRadius: BorderRadius.circular(8.0), // Bentuk border
//                 ),
//                 columns: const [
//                   DataColumn(label: Text('NOMOR JO')),
//                   DataColumn(label: Text('NAMA AGEN')),
//                   DataColumn(label: Text('KOTA')),
//                   DataColumn(label: Text('KANWIL')),
//                   DataColumn(label: Text('JADWAL PM')),
//                   DataColumn(label: Text('TANGGAL PROSES PM')),
//                   DataColumn(label: Text('TANGGAL VISITED')),
//                   DataColumn(label: Text('DETAIL')),
//                 ],
//                 rows: dataList.map<DataRow>((Map<String, String> data) {
//                   return DataRow(
//                     cells: [
//                       DataCell(Text(data['nomor_jo']!)),
//                       DataCell(Text(data['nama_agen']!)),
//                       DataCell(Text(data['kota']!)),
//                       DataCell(Text(data['id_kanwil']!)),
//                       DataCell(Text(data['jadwal_pm']!)),
//                       DataCell(Text(data['tanggal_proses_pm']!)),
//                       DataCell(Text(data['tanggal_visited']!)),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(Icons.perm_device_info),
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => LaporanPMDetail(
//                                     pm: PmData(
//                                   noSpk: data['nomor_jo'] ?? '',
//                                   jadwalPm: data['jadwal_pm'] ?? '',
//                                   tanggalProses:
//                                       data['tanggal_proses_pm'] ?? '',
//                                   namaAgen: data['nama_agen'] ?? '',
//                                   teleponAgen: data['telepon_agen'] ?? '',
//                                   alamatAgen: data['alamat_agen'] ?? '',
//                                   kota: data['kota'] ?? '',
//                                   kanwil: data['id_kanwil'] ?? '',
//                                   serialNumber: data['serial_number'] ?? '',
//                                   tid: data['tid'] ?? '',
//                                   mid: data['mid'] ?? '',
//                                   catatanProsesPm:
//                                       data['catatan_proses_pm'] ?? '',
//                                 )),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
