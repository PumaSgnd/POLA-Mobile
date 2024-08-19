import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:io/ansi.dart';
import 'package:pola/Pemasangan/listagen/DetailAgen.dart';
import 'package:pola/Pemasangan/laporan/EditList.dart';
//Menu
import '../Menu/MenuPemasangan.dart';
import '../user/User.dart';

class LaporanPemasangan extends StatefulWidget {
  static const String id = "/LaporanPemasangan";
  final User? userData;
  const LaporanPemasangan({Key? key, required this.userData}) : super(key: key);
  @override
  _LaporanPemasanganState createState() => _LaporanPemasanganState();
}

class Laporan {
  String? idSPK;
  final String isAktif;
  final String noSPK;
  final String agentName;
  final String kota;
  final String kanwil;
  final String serialNumber;
  final DateTime spkDiterima;
  final DateTime selesaiPemasangan;
  final String catatan;
  final String status;

  Laporan({
    this.idSPK,
    required this.isAktif,
    required this.noSPK,
    required this.agentName,
    required this.kota,
    required this.kanwil,
    required this.serialNumber,
    required this.spkDiterima,
    required this.selesaiPemasangan,
    this.catatan = '',
    required this.status,
  });
}

class _LaporanPemasanganState extends State<LaporanPemasangan> {
  List<Laporan> laporanPemasangan = [];
  List<Laporan> filteredLaporanPemasangan = [];
  String? selectedKanwil;
  String? selectedKota;
  List<String> kanwilList = [];
  List<String> kotaList = [];
  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;
  String _searchQuery = '';
  List<Laporan> filteredLaporanByKanwilAndKota = [];

  final Map<String, String> statusMapping = {
    'done': 'Sudah Pasang',
    'on progress': 'Sudah Pasang',
    'pending': 'Sudah Pasang',
    'failed': 'Sudah Pasang',
  };

  Future<void> fetchData() async {
    try {
      // Fetch data from API
      final response = await http
          .get(Uri.parse('http://10.20.20.174/fms/api/spk_api/get_all'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonResponse['data']);

        final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        List<Laporan> tempLaporan = data
            .map((item) {
              return Laporan(
                idSPK: item['id'] ?? '',
                isAktif: item['is_aktif'] ?? '0',
                noSPK: item['no_spk'] ?? '',
                agentName: item['nama_agen'] ?? '',
                serialNumber: item['serial_number'] ?? '',
                kota: item['kota'] ?? '',
                kanwil: item['kanwil'] ?? '',
                spkDiterima: item['tgl_spk'] != null && item['jam_spk'] != null
                    ? dateTimeFormat
                        .parse('${item['tgl_spk']} ${item['jam_spk']}')
                    : DateTime.now(),
                selesaiPemasangan: item['tgl_pemasangan'] != null &&
                        item['jam_pemasangan'] != null
                    ? dateTimeFormat.parse(
                        '${item['tgl_pemasangan']} ${item['jam_pemasangan']}')
                    : DateTime.now(),
                catatan: item['catatan'] ?? '',
                status: item['status']?.toLowerCase() ?? '',
              );
            })
            .where((laporan) => laporan.status == 'sudah pasang')
            .toList();

        setState(() {
          laporanPemasangan = tempLaporan;
          filteredLaporanPemasangan = laporanPemasangan;
        });

        _filterLaporan();
      } else {
        print('Failed to load data from API');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _filterLaporan() {
    setState(() {
      filteredLaporanPemasangan = laporanPemasangan.where((item) {
        final noSpk = item.noSPK.toLowerCase();
        final agentName = item.agentName.toLowerCase();
        final kota = item.kota.toLowerCase();
        final kanwil = item.kanwil.toLowerCase();
        final serialNumber = item.serialNumber.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        final status = item.status;

        final matchesKanwil = selectedKanwil == null ||
            selectedKanwil!.isEmpty ||
            item.kanwil.toLowerCase() == selectedKanwil!.toLowerCase();
        final matchesKota = selectedKota == null ||
            selectedKota!.isEmpty ||
            item.kota.toLowerCase() == selectedKota!.toLowerCase();
        final matchesStatus = selectedStatus == null ||
            selectedStatus!.isEmpty ||
            selectedStatus == 'semua' ||
            status == statusMapping[selectedStatus];

        return (noSpk.contains(searchLower) ||
                agentName.contains(searchLower) ||
                kota.contains(searchLower) ||
                kanwil.contains(searchLower) ||
                serialNumber.contains(searchLower)) &&
            matchesKanwil &&
            matchesKota &&
            matchesStatus;
      }).toList();
    });
  }

  Future<void> fetchKanwilList() async {
    final String apiUrl = "http://10.20.20.174/fms/api/kanwil_api/get_all";
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
    final String baseUrl = "http://10.20.20.174/fms/api/kota_api/kota_get_all";
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
        builder: (context) => MenuPemasangan(userData: widget.userData),
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
              padding: EdgeInsets.all(20.0),
              child: Text(
                'List Order Pemasangan',
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
                                _filterLaporan();
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
                                _filterLaporan();
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Status (Semua)',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>[
                        'semua',
                        'done',
                        'on progress',
                        'pending',
                        'failed'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                          _filterLaporan();
                        });
                      },
                      value: selectedStatus ?? 'semua',
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
                          fetchData(); // Re-fetch the data to apply the search filter
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
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      'Pemasangan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  startDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  endDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      columns: const [
                        DataColumn(label: Text('')),
                        DataColumn(
                            label: Text(
                          'NOMOR JO',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                        DataColumn(
                            label: Text(
                          'AGEN',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                        DataColumn(
                            label: Text(
                          'SERIAL NUMBER',
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
                          'JO DITERIMA',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                        DataColumn(
                            label: Text(
                          'SELESAI PEMASANGAN',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                        DataColumn(
                            label: Text(
                          'CATATAN',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                        DataColumn(
                          label: Center(
                              child: Text(
                            'AKSI',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )),
                        ),
                      ],
                      source: LaporanDataSource(filteredLaporanPemasangan),
                      rowsPerPage: 5,
                      columnSpacing: 16.0,
                      horizontalMargin: 10.0,
                      dataRowHeight: 55,
                      headingRowHeight: 50,
                    ),
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

class LaporanDataSource extends DataTableSource {
  final List<Laporan> laporanPemasangan;
  LaporanDataSource(this.laporanPemasangan);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= laporanPemasangan.length) {
      return DataRow.byIndex(index: index, cells: []);
    }
    final laporan = laporanPemasangan[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: laporan.isAktif == '1' ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              laporan.isAktif == '1' ? 'Aktif' : 'Tidak Aktif',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(Text(laporan.noSPK)),
        DataCell(Text(laporan.agentName)),
        DataCell(Text(laporan.serialNumber)),
        DataCell(Text(laporan.kota)),
        DataCell(Text(laporan.kanwil)),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              DateFormat('dd MMMM yyyy', 'id_ID').format(laporan.spkDiterima),
            ),
            Text(
              DateFormat('HH:mm:ss').format(laporan.spkDiterima),
            ),
          ],
        )),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              DateFormat('dd MMMM yyyy', 'id_ID')
                  .format(laporan.selesaiPemasangan),
            ),
            Text(
              DateFormat('HH:mm:ss').format(laporan.selesaiPemasangan),
            ),
          ],
        )),
        DataCell(
          Container(
            width: 150.0,
            child: Text(
              laporan.catatan,
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ),
        DataCell(
          Builder(
            builder: (BuildContext context) => PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'Detail') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        // id: laporan.idSPK ?? 'defaultID',\
                        id: laporan.idSPK ?? 'id',
                        userData: null,
                      ),
                    ),
                  );
                } else if (value == 'Edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditList(
                        id: laporan.idSPK,
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
                  value: 'Edit',
                  child: Text('Edit'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => laporanPemasangan.length;
  @override
  int get selectedRowCount => 0;
}

Color _getStatusColor(String status, String is_aktif) {
  if ((status == 'Belum Registrasi' || status == 'Belum Pasang') &&
      is_aktif == '1') {
    return Colors.red;
  } else if (status == 'Sudah Pasang' && is_aktif == '1') {
    return Colors.green;
  } else if (is_aktif == '0') {
    return Colors.red;
  } else {
    return Colors.transparent;
  }
}

String _getStatusText(String status, String is_aktif) {
  if ((status == 'Belum Registrasi' || status == 'Belum Pasang') &&
      is_aktif == '1') {
    return status;
  } else if (status == 'Sudah Pasang' && is_aktif == '1') {
    return status;
  } else if (is_aktif == '0') {
    return 'Ditarik';
  } else {
    return '';
  }
}
