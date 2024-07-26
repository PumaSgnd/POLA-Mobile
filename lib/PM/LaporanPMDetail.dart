// import 'package:flutter/material.dart';
// import '../PM/LaporanPM.dart';

// class LaporanPMDetail extends StatelessWidget {
//   static const String id = "/LaporanPMDetail";
//   final PmData pm;

//   late PmData dummyData;
//   void initState() {
//     dummyData = PmData.getDummyData();
//   }

//   LaporanPMDetail({required this.pm});

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
//                 builder: (context) => const LaporanPM(),
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
//               crossAxisAlignment: CrossAxisAlignment
//                   .start, // Membuat konten dalam Card dimulai dari atas
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: Container(
//                       width: 300.0,
//                       height: 268.0 + 30.0,
//                       child: Column(
//                         children: [
//                           const ListTile(
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 20.0),
//                             title: Text(
//                               'JO',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 5.0),
//                               child: Column(
//                                 children: [
//                                   buildDataRow('Nomor JO', pm.noSpk),
//                                   buildDataRow('Jadwal PM', pm.jadwalPm),
//                                   buildDataRow('Proses PM', pm.tanggalProses),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Card(
//                     child: Container(
//                       width: 300.0,
//                       height: 268.0 + 30.0,
//                       child: Column(
//                         children: [
//                           const ListTile(
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 20.0),
//                             title: Text(
//                               'Agen',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 5.0),
//                               child: Column(
//                                 children: [
//                                   buildDataRow('Nama Agen', pm.namaAgen),
//                                   buildDataRow('Telepon', pm.teleponAgen),
//                                   buildDataRow('Alamat Agen', pm.alamatAgen),
//                                   buildDataRow('Kota', pm.kota),
//                                   buildDataRow('Kanwil', pm.kanwil),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: Container(
//                       width: 300.0,
//                       height: 252.0,
//                       child: Column(
//                         children: [
//                           const ListTile(
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 20.0),
//                             title: Text(
//                               'Perangkat',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 5.0),
//                               child: Column(
//                                 children: [
//                                   buildDataRow(
//                                       'Serial Number', pm.serialNumber),
//                                   buildDataRow('TID', pm.tid),
//                                   buildDataRow('MID', pm.mid),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Card(
//                     child: Container(
//                       width: 300.0,
//                       height: 252.0,
//                       child: Column(
//                         children: [
//                           const ListTile(
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 20.0),
//                             title: Text(
//                               'Keterangan',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 5.0),
//                               child: Column(
//                                 children: [
//                                   buildDataRow('Catatan', pm.catatanProsesPm),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDataRow(String label, String value) {
//     return ListTile(
//       title: Text(label),
//       trailing: Text(value),
//     );
//   }
// }

// class PmData {
//   final String noSpk;
//   final String jadwalPm;
//   final String tanggalProses;
//   final String namaAgen;
//   final String teleponAgen;
//   final String alamatAgen;
//   final String kota;
//   final String kanwil;
//   final String serialNumber;
//   final String tid;
//   final String mid;
//   final String catatanProsesPm;

//   PmData({
//     required this.noSpk,
//     required this.jadwalPm,
//     required this.tanggalProses,
//     required this.namaAgen,
//     required this.teleponAgen,
//     required this.alamatAgen,
//     required this.kota,
//     required this.kanwil,
//     required this.serialNumber,
//     required this.tid,
//     required this.mid,
//     required this.catatanProsesPm,
//   });

//   static PmData getDummyData() {
//     return PmData(
//       noSpk: 'JO123',
//       jadwalPm: '01/02/2023',
//       tanggalProses: '01/01/2023',
//       namaAgen: 'Agen 1',
//       teleponAgen: '1234567890',
//       alamatAgen: 'Alamat Agen 1',
//       kota: 'Kota 1',
//       kanwil: 'Kanwil 1',
//       serialNumber: 'SN123',
//       tid: 'TID123',
//       mid: 'MID123',
//       catatanProsesPm: 'Catatan PM 1',
//     );
//   }
// }
