// ignore_for_file: cast_from_null_always_fails, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
//Menu
import '../Menu/MenuDrop.dart';
import '../Penarikan/listwd/DetailWD.dart';
import '../Penarikan/laporan/EditAgen.dart';
import '../user/User.dart';

class LaporanWD extends StatefulWidget {
  static const String id = "/LaporanWD";
  final User? userData;
  const LaporanWD({Key? key, required this.userData}) : super(key: key);
  @override
  LaporanWDPage createState() => LaporanWDPage();
}

class DataPenarikan {
  final String noSPKPenarikan;
  final String namaAgen;
  final String kota;
  final String kanwil;
  final String serialNumber;
  final DateTime tanggalPemasangan;
  final DateTime tanggalPenarikan;

  DataPenarikan({
    required this.noSPKPenarikan,
    required this.namaAgen,
    required this.kota,
    required this.kanwil,
    required this.serialNumber,
    required this.tanggalPemasangan,
    required this.tanggalPenarikan,
  });
}

class LaporanWDPage extends State<LaporanWD> {
  List<DataPenarikan> penarikanList = [];
  List<DataPenarikan> filteredPenarikanList = [];
  String? selectedKanwil;
  String? selectedKota;
  String? selectedStatus;
  String _searchQuery = '';

  Future<void> fetchData() async {
    try {
      // Dummy data for testing
      final List<Map<String, dynamic>> dummyData = [
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '15:00:00',
        },
        {
          'no_spkPenarikan': 'SPK001',
          'nama_agen': 'Agen 2',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
          'tgl_penarikan': '2023-08-10',
          'jam_penarikan': '10:00:00',
        },
        // Add more data as needed
      ];

      List<DataPenarikan> tempDataPenarikan = dummyData.map((item) {
        return DataPenarikan(
          noSPKPenarikan: item['no_spkPenarikan'],
          namaAgen: item['nama_agen'],
          kota: item['kota'],
          kanwil: item['kanwil'],
          serialNumber: item['serialnumber'],
          tanggalPemasangan: DateTime.parse(
              '${item['tgl_pemasangan']} ${item['jam_pemasangan']}'),
          tanggalPenarikan: DateTime.parse(
              '${item['tgl_penarikan']} ${item['jam_penarikan']}'),
        );
      }).toList();

      setState(() {
        penarikanList = tempDataPenarikan;

        // Apply search filter
        filteredPenarikanList = penarikanList.where((DataPenarikan) {
          final searchLower = _searchQuery.toLowerCase();
          return DataPenarikan.noSPKPenarikan.toLowerCase().contains(searchLower) ||
              DataPenarikan.namaAgen.toLowerCase().contains(searchLower) ||
              DataPenarikan.kota.toLowerCase().contains(searchLower) ||
              DataPenarikan.kanwil.toLowerCase().contains(searchLower) ||
              DataPenarikan.serialNumber.toLowerCase().contains(searchLower);
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      fetchData();
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WithDrawal(userData: widget.userData),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFE4EDF3),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Laporan Penarikan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, left: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kanwil (Semua)',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'kanwil1',
                                child: Text('Kanwil 1'),
                              ),
                              DropdownMenuItem(
                                value: 'kanwil2',
                                child: Text('Kanwil 2'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedKanwil = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kota (Semua)',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'kota1',
                                child: Text('Kota 1'),
                              ),
                              DropdownMenuItem(
                                value: 'kota2',
                                child: Text('Kota 2'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedKota = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Status (Semua)',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'status1',
                          child: Text('Status 1'),
                        ),
                        DropdownMenuItem(
                          value: 'status2',
                          child: Text('Status 2'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          fetchData();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Export',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  PaginatedDataTable(
                    columns: const [
                      DataColumn(
                          label: Text(
                        'NOMOR JO PENARIKAN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'AGEN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'KOTA',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'KANWIL',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'SERIAL NUMBER',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'TANGGAL PEMASANGAN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'TANGGAL PENARIKAN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'AKSI',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ],
                    source: PenarikanDataSource(filteredPenarikanList, context),
                    rowsPerPage: 5,
                    columnSpacing: 16.0,
                    horizontalMargin: 10.0,
                    dataRowHeight: 55,
                    headingRowHeight: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PenarikanDataSource extends DataTableSource {
  final List<DataPenarikan> penarikanList;
  final BuildContext context;

  PenarikanDataSource(this.penarikanList, this.context);

  @override
  DataRow getRow(int index) {
    final DataPenarikan penarikan = penarikanList[index];

    return DataRow(cells: [
      DataCell(Text(penarikan.noSPKPenarikan)),
      DataCell(Text(penarikan.namaAgen)),
      DataCell(Text(penarikan.kota)),
      DataCell(Text(penarikan.kanwil)),
      DataCell(Text(penarikan.serialNumber)),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID').format(penarikan.tanggalPemasangan),
          ),
          Text(
            DateFormat('HH:mm:ss').format(penarikan.tanggalPemasangan),
          ),
        ],
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID').format(penarikan.tanggalPenarikan),
          ),
          Text(
            DateFormat('HH:mm:ss').format(penarikan.tanggalPenarikan),
          ),
        ],
      )),
      DataCell(
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Handle the menu item click
            if (value == 'Detail') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailPage(detailId: '', userData: null,),
                ),
              );
            } else if (value == 'Edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditAgen(userData: null,
                  ),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Detail',
              child: Text('Detail'),
            ),
            const PopupMenuItem<String>(
              value: 'Edit',
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => penarikanList.length;

  @override
  int get selectedRowCount => 0;
}
