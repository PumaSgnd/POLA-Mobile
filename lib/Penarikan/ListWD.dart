import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//Menu
import '../Menu/MenuDrop.dart';
import '../user/User.dart';
import '../Penarikan/listwd/EditWD.dart';
import '../Penarikan/listwd/DetailWD.dart';

class ListWD extends StatefulWidget {
  static const String id = "/LaporanWD";
  final User? userData;
  const ListWD({Key? key, required this.userData}) : super(key: key);
  @override
  ListWDPage createState() => ListWDPage();
}

class DataPenarikan {
  String? id;
  final String noSPKPenarikan;
  final String namaAgen;
  final String kota;
  final String kanwil;
  final String serialNumber;
  final String status;
  final DateTime tanggalPemasangan;
  final DateTime tanggalPenarikan;

  DataPenarikan({
    this.id,
    required this.noSPKPenarikan,
    required this.namaAgen,
    required this.kota,
    required this.kanwil,
    required this.serialNumber,
    required this.status,
    required this.tanggalPemasangan,
    required this.tanggalPenarikan,
  });
}

class ListWDPage extends State<ListWD> {
  List<DataPenarikan> penarikanList = [];
  List<DataPenarikan> filteredPenarikanList = [];
  String? selectedKanwil;
  String? selectedKota;
  List<String> kanwilList = [];
  List<String> kotaList = [];
  String _searchQuery = '';

  void filterAgents() {
    setState(() {
      filteredPenarikanList = penarikanList.where((agent) {
        final query = _searchQuery.toLowerCase();
        return (selectedKanwil == null || agent.kanwil == selectedKanwil) &&
            (selectedKota == null || agent.kota == selectedKota) &&
            (agent.namaAgen.toLowerCase().contains(query) ||
                agent.kota.toLowerCase().contains(query) ||
                agent.kanwil.toLowerCase().contains(query) ||
                agent.noSPKPenarikan.toLowerCase().contains(query) ||
                agent.serialNumber.toLowerCase().contains(query) ||
                agent.status.toLowerCase().contains(query));
      }).toList();
    });
  }

  Future<void> fetchKanwilList() async {
    final String apiUrl = "http://192.168.50.69/pola/api/kanwil_api/get_all";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> kanwilData = responseData['data'];
          setState(() {
            kanwilList = kanwilData.map<String>((item) {
              return item['nama'];
            }).toList();
          });
        } else {
          print("Error fetching Kanwil data");
        }
      } else {
        print("Error fetching Kanwil data");
      }
    } catch (error) {
      print('An error occurred while fetching Kanwil data: $error');
    }
  }

  Future<void> fetchKotaList() async {
    final String baseUrl = "http://192.168.50.69/pola/api/kota_api/kota_get_all";
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> kotaData = responseData['data'];
          setState(() {
            kotaList = kotaData.map<String>((item) {
              return item['city_name'];
            }).toList();
          });
        } else {
          print("Error fetching Kota data");
        }
      } else {
        print("Error fetching Kota data");
      }
    } catch (error) {
      print('An error occurred while fetching Kota data: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.50.69/pola/api/penarikan_api/get_all'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        print('Data received: $data');

        setState(() {
          penarikanList.clear();
          for (var item in data) {
            try {
              penarikanList.add(
                DataPenarikan(
                  id: item['id'] ?? '',
                  noSPKPenarikan: item['no_spk_penarikan'] ?? '',
                  namaAgen: item['nama_agen'] ?? '',
                  kota: item['kota'] ?? '',
                  kanwil: item['kanwil'] ?? '',
                  serialNumber: item['serial_number'] ?? '',
                  status: item['is_aktif'] ?? '',
                  tanggalPemasangan:
                      DateTime.parse(item['tanggal_pemasangan'] ?? ''),
                  tanggalPenarikan:
                      DateTime.parse(item['tanggal_penarikan'] ?? ''),
                ),
              );
            } catch (e) {
              print('Error parsing item: $item - $e');
            }
          }
          filterAgents();
        });
      } else {
        print('Error: Status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Gagal mengambil data dari API');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      fetchData();
    });
    fetchKanwilList();
    fetchKotaList();
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
        backgroundColor: const Color(0xFFE4EDF3),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'List Penarikan',
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
                              const EdgeInsets.only(right: 10.0, left: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kanwil (Semua)',
                              border: OutlineInputBorder(),
                            ),
                            items: kanwilList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKanwil = value;
                                filterAgents();
                              });
                            },
                            value: selectedKanwil,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kota (Semua)',
                              border: OutlineInputBorder(),
                            ),
                            items: kotaList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 100.0),
                                  child: Text(
                                    value,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKota = value;
                                filterAgents();
                              });
                            },
                            value: selectedKota,
                          ),
                        ),
                      ),
                    ],
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
                          filterAgents();
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
                        'STATUS',
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
    assert(index >= 0);
    if (index >= penarikanList.length) {
      return DataRow.byIndex(index: index, cells: []);
    }

    final DataPenarikan penarikan = penarikanList[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(penarikan.noSPKPenarikan)),
      DataCell(Text(penarikan.namaAgen)),
      DataCell(Text(penarikan.kota)),
      DataCell(Text(penarikan.kanwil)),
      DataCell(Text(penarikan.serialNumber)),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID')
                .format(penarikan.tanggalPemasangan),
          ),
          Text(
            DateFormat('HH:mm:ss').format(penarikan.tanggalPemasangan),
          ),
        ],
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID')
                .format(penarikan.tanggalPenarikan),
          ),
          Text(
            DateFormat('HH:mm:ss').format(penarikan.tanggalPenarikan),
          ),
        ],
      )),
      DataCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _getStatusColor(
                penarikan.status), // Determine color based on status
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            _getStatusText(penarikan.status), // Determine text based on status
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      DataCell(
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Handle the menu item click
            if (value == 'Detail') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: penarikan.id,
                    userData: null,
                  ),
                ),
              );
            } else if (value == 'Proses') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditWD(
                    id: penarikan.id,
                    userData: null,
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
              value: 'Proses',
              child: Text('Proses'),
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

Color _getStatusColor(String status) {
  if (status == '1') {
    return Colors.grey;
  } else if (status == '0') {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

String _getStatusText(String status) {
  if (status == '0') {
    return 'Selesai';
  } else if (status == '1') {
    return 'Menunggu Proses';
  } else {
    return 'Ditarik';
  }
}
