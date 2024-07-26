// import 'package:flutter/material.dart';
// import '../Menu/MenuPM.dart';

// class JadwalPM extends StatefulWidget {
//   static const String id = "/JadwalPM";
//   const JadwalPM({Key? key}) : super(key: key);

//   @override
//   _JadwalPMState createState() => _JadwalPMState();
// }

// class _JadwalPMState extends State<JadwalPM> {
//   String? filterKanwil = 'Kanwil (Semua)';
//   String? filterKota = 'Kota (Semua)';
//   String searchText = '';
//   List<Map<String, String>> dataList = [
//     {
//       'nomor_jo': 'JO123',
//       'nama_agen': 'Agen 1',
//       'kota': 'Kota 1',
//       'id_kanwil': 'Kanwil 1',
//       'serial_number': 'SN123',
//       'jadwal_pm': '01/01/2023',
//     },
//     {
//       'nomor_jo': 'JO124',
//       'nama_agen': 'Agen 2',
//       'kota': 'Kota 2',
//       'id_kanwil': 'Kanwil 2',
//       'serial_number': 'SN124',
//       'jadwal_pm': '02/01/2023',
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
//                 'Jadwal Preventive Maintenance',
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
//                         // primary: Colors.blue,
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
//                               filterKanwil = value;
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
//                               filterKota = value;
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
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey), // Border untuk table
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: DataTable(
//                   columnSpacing: 16.0,
//                   dividerThickness: 1.0,
//                   columns: const [
//                     DataColumn(
//                       label: Text('NOMOR JO', style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label:
//                           Text('NAMA AGEN', style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label: Text('KOTA', style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label: Text('KANWIL', style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label: Text('SERIAL NUMBER',
//                           style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label:
//                           Text('JADWAL PM', style: TextStyle(fontSize: 12.0)),
//                     ),
//                     DataColumn(
//                       label: Text('AKSI', style: TextStyle(fontSize: 12.0)),
//                     ),
//                   ],
//                   rows: dataList
//                       .where((data) =>
//                           (filterKanwil == 'Kanwil (Semua)' ||
//                               data['id_kanwil'] == filterKanwil) &&
//                           (filterKota == 'Kota (Semua)' ||
//                               data['kota'] == filterKota) &&
//                           data['nama_agen']!
//                               .toLowerCase()
//                               .contains(searchText.toLowerCase()))
//                       .map(
//                         (data) => DataRow(
//                           cells: [
//                             DataCell(
//                               Text(data['nomor_jo']!),
//                             ),
//                             DataCell(
//                               Text(data['nama_agen']!),
//                             ),
//                             DataCell(
//                               Text(data['kota']!),
//                             ),
//                             DataCell(
//                               Text(data['id_kanwil']!),
//                             ),
//                             DataCell(
//                               Text(data['serial_number']!),
//                             ),
//                             DataCell(
//                               Text(data['jadwal_pm']!),
//                             ),
//                             DataCell(
//                               PopupMenuButton<String>(
//                                 onSelected: (value) {
//                                   // Tambahkan logika sesuai dengan pilihan yang dipilih di sini
//                                   if (value == 'Detail') {
//                                     // Logika untuk tampilkan detail
//                                   } else if (value == 'Proses') {
//                                     // Logika untuk proses data
//                                   }
//                                 },
//                                 itemBuilder: (BuildContext context) =>
//                                     <PopupMenuEntry<String>>[
//                                   const PopupMenuItem<String>(
//                                     value: 'Detail',
//                                     child: ListTile(
//                                       title: Text('Detail'),
//                                     ),
//                                   ),
//                                   const PopupMenuItem<String>(
//                                     value: 'Proses',
//                                     child: ListTile(
//                                       title: Text('Proses'),
//                                     ),
//                                   ),
//                                 ],
//                                 child: const Icon(Icons.more_vert),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
