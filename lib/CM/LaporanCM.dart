// // ignore_for_file: cast_from_null_always_fails, use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// //Menu
// import '../Menu/MenuHome.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPemasangan.dart';
// import '../Menu/MenuPM.dart';
// import '../Menu/Profile.dart';
// import '../user/User.dart';

// class LaporanCM extends StatefulWidget {
//   static const String id = "/LaporanCM";
//   const LaporanCM({Key? key}) : super(key: key);
//   @override
//   LaporanCMPage createState() => LaporanCMPage();
// }

// class LaporanCMPage extends State<LaporanCM> {
//   final List<String> _menuItems = [
//     'Home',
//     'Pemasangan',
//     'Preventive Maintenance',
//     'Corrective Maintenance',
//     'Profile',
//   ];

//   List<DataLaporan> laporanList = [
//     DataLaporan(
//       no: '1',
//       namaAgen: 'Agen 1',
//       tid: 'TID001',
//       kanwil: 'Kanwil 1',
//       tanggalLaporan: DateTime(2023, 7, 15, 10, 30),
//       tanggalProsesCM: DateTime(2023, 7, 16, 9, 45),
//     ),
//     DataLaporan(
//       no: '2',
//       namaAgen: 'Agen 2',
//       tid: 'TID002',
//       kanwil: 'Kanwil 2',
//       tanggalLaporan: DateTime(2023, 7, 16, 14, 15),
//       tanggalProsesCM: DateTime(2023, 7, 17, 11, 30),
//     ),
//     // Tambahkan data laporan lainnya di sini
//   ];

//   List<DataLaporan> filteredLaporanList = [];

//   final List<String> agenList = [
//     'Semua Agen',
//     'Agen 1',
//     'Agen 2',
//     // Add more agen options here
//   ];

//   String? selectedAgen;

//   final List<String> kanwilList = [
//     'Semua Kanwil',
//     'Kanwil 1',
//     'Kanwil 2',
//     // Add more kanwil options here
//   ];

//   String? selectedKanwil;

//   DateTime selectedDateFrom = DateTime.now();
//   DateTime selectedDateTo = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     filteredLaporanList = List.from(laporanList);
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
//       body: ListView(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Data Laporan CM',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   showSearch(
//                     context: context,
//                     delegate: DataSearchDelegate(
//                         laporanList), // Tambahkan argumen laporanList di sini
//                   );
//                 },
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Agen',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Container(
//                     height: 40,
//                     child: DropdownButtonFormField<String>(
//                       isExpanded: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Semua Agen',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: selectedAgen,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedAgen = newValue;
//                           filterLaporanList();
//                         });
//                       },
//                       items: agenList.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Kantor Wilayah',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Container(
//                     height: 40,
//                     child: DropdownButtonFormField<String>(
//                       isExpanded: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Semua KanWil',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: selectedKanwil,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedKanwil = newValue;
//                           filterLaporanList();
//                         });
//                       },
//                       items: kanwilList.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Tanggal Proses',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     readOnly: true,
//                     onTap: () => _selectDate(context, true),
//                     decoration: const InputDecoration(
//                       labelText: 'Dari',
//                       border: OutlineInputBorder(),
//                     ),
//                     controller: TextEditingController(
//                       text: DateFormat('yyyy-MM-dd').format(selectedDateFrom),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextField(
//                     readOnly: true,
//                     onTap: () => _selectDate(context, false),
//                     decoration: const InputDecoration(
//                       labelText: 'Sampai',
//                       border: OutlineInputBorder(),
//                     ),
//                     controller: TextEditingController(
//                       text: DateFormat('yyyy-MM-dd').format(selectedDateTo),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 shrinkWrap: true,
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columnSpacing: 16.0, // Mengatur jarak antara kolom
//                       columns: const [
//                         DataColumn(label: Text('No')),
//                         DataColumn(label: Text('Nama Agen')),
//                         DataColumn(label: Text('TID')),
//                         DataColumn(label: Text('KanWil')),
//                         DataColumn(label: Text('Tanggal Laporan')),
//                         DataColumn(label: Text('Tanggal Proses CM')),
//                         DataColumn(label: Text('Durasi CM')),
//                         DataColumn(label: Text('Detail')),
//                       ],
//                       rows: [
//                         for (int i = 0; i < filteredLaporanList.length; i++)
//                           DataRow(
//                             cells: [
//                               DataCell(Text(filteredLaporanList[i].no)),
//                               DataCell(Text(filteredLaporanList[i].namaAgen)),
//                               DataCell(Text(filteredLaporanList[i].tid)),
//                               DataCell(Text(filteredLaporanList[i].kanwil)),
//                               DataCell(Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     height: 8.0,
//                                   ),
//                                   Text(DateFormat('yyyy-MM-dd').format(
//                                       filteredLaporanList[i].tanggalLaporan)),
//                                   Text(DateFormat('HH:mm:ss').format(
//                                       filteredLaporanList[i].tanggalLaporan)),
//                                 ],
//                               )),
//                               DataCell(Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     height: 8.0,
//                                   ),
//                                   Text(DateFormat('yyyy-MM-dd').format(
//                                       filteredLaporanList[i].tanggalProsesCM)),
//                                   Text(DateFormat('HH:mm:ss').format(
//                                       filteredLaporanList[i].tanggalProsesCM)),
//                                 ],
//                               )),
//                               DataCell(Text(
//                                 calculateDurasiCM(
//                                     filteredLaporanList[i].tanggalLaporan,
//                                     filteredLaporanList[i].tanggalProsesCM),
//                               )),
//                               DataCell(
//                                 IconButton(
//                                   icon: const Icon(Icons.info_outline),
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text('Detail Laporan'),
//                                           content: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                   'No: ${filteredLaporanList[i].no}'),
//                                               Text(
//                                                   'Nama Agen: ${filteredLaporanList[i].namaAgen}'),
//                                               Text(
//                                                   'TID: ${filteredLaporanList[i].tid}'),
//                                               Text(
//                                                   'KanWil: ${filteredLaporanList[i].kanwil}'),
//                                               Text(
//                                                   'Tanggal Laporan: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(filteredLaporanList[i].tanggalLaporan)}'),
//                                               Text(
//                                                   'Tanggal Proses CM: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(filteredLaporanList[i].tanggalProsesCM)}'),
//                                               Text(
//                                                   'Durasi CM: ${calculateDurasiCM(filteredLaporanList[i].tanggalLaporan, filteredLaporanList[i].tanggalProsesCM)}'),
//                                             ],
//                                           ),
//                                           actions: [
//                                             ElevatedButton(
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text('Tutup'),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void filterLaporanList() {
//     setState(() {
//       filteredLaporanList = laporanList
//           .where((data) =>
//               (selectedAgen == null || data.namaAgen == selectedAgen) &&
//               (selectedKanwil == null || data.kanwil == selectedKanwil) &&
//               (data.tanggalLaporan.isAfter(selectedDateFrom) &&
//                   data.tanggalLaporan.isBefore(selectedDateTo)))
//           .toList();
//     });
//   }

//   String calculateDurasiCM(DateTime tanggalLaporan, DateTime tanggalProsesCM) {
//     Duration difference = tanggalProsesCM.difference(tanggalLaporan);
//     int hours = difference.inHours;
//     return '$hours jam';
//   }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: isFromDate ? selectedDateFrom : selectedDateTo,
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2024),
//     );

//     if (selectedDate != null) {
//       final TimeOfDay? selectedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );

//       if (selectedTime != null) {
//         setState(() {
//           if (isFromDate) {
//             selectedDateFrom = DateTime(
//               selectedDate.year,
//               selectedDate.month,
//               selectedDate.day,
//               selectedTime.hour,
//               selectedTime.minute,
//             );
//           } else {
//             selectedDateTo = DateTime(
//               selectedDate.year,
//               selectedDate.month,
//               selectedDate.day,
//               selectedTime.hour,
//               selectedTime.minute,
//             );
//           }
//           filterLaporanList();
//         });
//       }
//     }
//   }
// }

// class DataLaporan {
//   final String no;
//   final String namaAgen;
//   final String tid;
//   final String kanwil;
//   final DateTime tanggalLaporan;
//   final DateTime tanggalProsesCM;

//   DataLaporan({
//     required this.no,
//     required this.namaAgen,
//     required this.tid,
//     required this.kanwil,
//     required this.tanggalLaporan,
//     required this.tanggalProsesCM,
//   });
// }

// class CustomSearchDelegate extends SearchDelegate<DataLaporan> {
//   final List<DataLaporan> laporanList;

//   CustomSearchDelegate(this.laporanList);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null as DataLaporan);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final List<DataLaporan> filteredList = laporanList
//         .where((data) =>
//             data.namaAgen.toLowerCase().contains(query.toLowerCase()) ||
//             data.tid.toLowerCase().contains(query.toLowerCase()) ||
//             data.kanwil.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: filteredList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final DataLaporan dataLaporan = filteredList[index];
//         return ListTile(
//           title: Text(dataLaporan.namaAgen),
//           subtitle: Text(dataLaporan.tid),
//           onTap: () {
//             close(context, dataLaporan);
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<DataLaporan> filteredList = laporanList
//         .where((data) =>
//             data.namaAgen.toLowerCase().contains(query.toLowerCase()) ||
//             data.tid.toLowerCase().contains(query.toLowerCase()) ||
//             data.kanwil.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: filteredList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final DataLaporan dataLaporan = filteredList[index];
//         return ListTile(
//           title: Text(dataLaporan.namaAgen),
//           subtitle: Text(dataLaporan.tid),
//           onTap: () {
//             query = dataLaporan.namaAgen;
//             close(context, dataLaporan);
//           },
//         );
//       },
//     );
//   }
// }

// class DataSearchDelegate extends SearchDelegate<DataLaporan> {
//   final List<DataLaporan> laporanList;

//   DataSearchDelegate(this.laporanList);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null as DataLaporan);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final List<DataLaporan> filteredList = laporanList
//         .where((data) =>
//             data.namaAgen.toLowerCase().contains(query.toLowerCase()) ||
//             data.tid.toLowerCase().contains(query.toLowerCase()) ||
//             data.kanwil.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: filteredList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final DataLaporan dataLaporan = filteredList[index];
//         return ListTile(
//           title: Text(dataLaporan.namaAgen),
//           subtitle: Text(dataLaporan.tid),
//           onTap: () {
//             close(context, dataLaporan);
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<DataLaporan> filteredList = laporanList
//         .where((data) =>
//             data.namaAgen.toLowerCase().contains(query.toLowerCase()) ||
//             data.tid.toLowerCase().contains(query.toLowerCase()) ||
//             data.kanwil.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: filteredList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final DataLaporan dataLaporan = filteredList[index];
//         return ListTile(
//           title: Text(dataLaporan.namaAgen),
//           subtitle: Text(dataLaporan.tid),
//           onTap: () {
//             query = dataLaporan.namaAgen;
//             close(context, dataLaporan);
//           },
//         );
//       },
//     );
//   }
// }
