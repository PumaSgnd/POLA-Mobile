// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pola/PM/HistoryPMDetail.dart';
// //Menu
// import '../Menu/MenuPM.dart';

// class HistoryPM extends StatefulWidget {
//   static const String id = "/HistoryPM";
//   const HistoryPM({Key? key}) : super(key: key);
//   @override
//   _HistoryPMState createState() => _HistoryPMState();
// }

// class _HistoryPMState extends State<HistoryPM> {
//   List<Data> dataList = [
//     Data(
//     noSpk: "JO001",
//     namaAgen: "Agen 1",
//     alamatAgen: "Alamat Agen 1",
//     kota: "Kota 1",
//     kanwil: "Kanwil 1",
//     serialNumber: "SN001",
//     tid: "TID001",
//     mid: "MID001",
//     jadwalPM: DateTime(2023, 10, 15),
//     tanggalProses: DateTime(2023, 10, 10),
//     visited: DateTime(2023, 10, 12),
//   ),
//   Data(
//     noSpk: "JO002",
//     namaAgen: "Agen 2",
//     alamatAgen: "Alamat Agen 2",
//     kota: "Kota 2",
//     kanwil: "Kanwil 2",
//     serialNumber: "SN002",
//     tid: "TID002",
//     mid: "MID002",
//     jadwalPM: DateTime(2023, 10, 20),
//     tanggalProses: DateTime(2023, 10, 18),
//     visited: DateTime(2023, 10, 22),
//   ),
//   Data(
//     noSpk: "JO003",
//     namaAgen: "Agen 3",
//     alamatAgen: "Alamat Agen 3",
//     kota: "Kota 3",
//     kanwil: "Kanwil 1",
//     serialNumber: "SN003",
//     tid: "TID003",
//     mid: "MID003",
//     jadwalPM: DateTime(2023, 10, 25),
//     tanggalProses: DateTime(2023, 10, 23),
//     visited: DateTime(2023, 10, 27),
//   ),
//   ];
//   String filterKanwil = 'Kanwil (Semua)';
//   String filterKota = 'Kota (Semua)';
//   String searchText = '';
//   DateTime? minDate;
//   DateTime? maxDate;

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
//                 'History Preventive Maintenance',
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
//                   DataColumn(label: Text('Nomor JO')),
//                   DataColumn(label: Text('Nama Agen')),
//                   DataColumn(label: Text('Alamat Agen')),
//                   DataColumn(label: Text('Kota')),
//                   DataColumn(label: Text('Kanwil')),
//                   DataColumn(label: Text('Serial Number')),
//                   DataColumn(label: Text('TID')),
//                   DataColumn(label: Text('MID')),
//                   DataColumn(label: Text('Jadwal PM')),
//                   DataColumn(label: Text('Tanggal Proses PM')),
//                   DataColumn(label: Text('Tanggal Visited')),
//                   DataColumn(label: Text('Detail')),
//                 ],
//                 rows: dataList.map((data) {
//                   return DataRow(
//                     cells: [
//                       DataCell(Text(data.noSpk)),
//                       DataCell(Text(data.namaAgen)),
//                       DataCell(Text(data.alamatAgen)),
//                       DataCell(Text(data.kota)),
//                       DataCell(Text(data.kanwil)),
//                       DataCell(Text(data.serialNumber)),
//                       DataCell(Text(data.tid)),
//                       DataCell(Text(data.mid)),
//                       DataCell(Text(data.formatJadwalPM())),
//                       DataCell(Text(data.formatTanggalProsesPM())),
//                       DataCell(Text(data.formatVisited())),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(Icons.perm_device_information_rounded),
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => HistoryPMDetail(pm: PmData.getDummyData()
//                                 ),
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

// class Data {
//   final String noSpk;
//   final String namaAgen;
//   final String alamatAgen;
//   final String kota;
//   final String kanwil;
//   final String serialNumber;
//   final String tid;
//   final String mid;
//   final DateTime jadwalPM;
//   final DateTime tanggalProses;
//   final DateTime visited;

//   Data({
//     required this.noSpk,
//     required this.namaAgen,
//     required this.alamatAgen,
//     required this.kota,
//     required this.kanwil,
//     required this.serialNumber,
//     required this.tid,
//     required this.mid,
//     required this.jadwalPM,
//     required this.tanggalProses,
//     required this.visited,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       noSpk: json['no_spk'],
//       namaAgen: json['nama_agen'],
//       alamatAgen: json['alamat_agen'],
//       kota: json['kota'],
//       kanwil: json['kanwil'],
//       serialNumber: json['serial_number'],
//       tid: json['tid'],
//       mid: json['mid'],
//       jadwalPM: DateTime.parse(json['jadwal_pm']),
//       tanggalProses: DateTime.parse(json['tanggal_proses']),
//       visited: DateTime.parse(json['visited']),
//     );
//   }

//   String formatJadwalPM() {
//     return DateFormat('dd MMMM yyyy').format(jadwalPM);
//   }

//   String formatTanggalProsesPM() {
//     return DateFormat('dd MMMM yyyy').format(tanggalProses);
//   }

//   String formatVisited() {
//     return DateFormat('dd MMMM yyyy').format(visited);
//   }
// }
