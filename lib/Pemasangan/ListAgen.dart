import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:pola/Pemasangan/listagen/DetailAgen.dart';
import 'package:pola/Pemasangan/listagen/EditAgen.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//Menu
import '../Menu/MenuPemasangan.dart';
import '../user/User.dart';

class ListAgen extends StatefulWidget {
  static const String id = "/ListAgen";
  final User? userData;
  const ListAgen({Key? key, required this.userData}) : super(key: key);
  @override
  _ListAgenMenuState createState() => _ListAgenMenuState();
}

class Agent {
  String? idSPK;
  final String is_aktif;
  final String noSPK;
  final String agentName;
  final String kota;
  final String kanwil;
  final String serialNumber;
  final String simCard;
  final String status;
  final DateTime installationDate;

  Agent({
    this.idSPK,
    required this.is_aktif,
    required this.noSPK,
    required this.agentName,
    required this.kota,
    required this.kanwil,
    required this.simCard,
    required this.serialNumber,
    required this.status,
    required this.installationDate,
  });
}

class _ListAgenMenuState extends State<ListAgen> {
  List<Agent> agents = [];
  List<Agent> filteredAgen = [];
  String? selectedKanwil;
  String? selectedKota;
  String? selectedStatus;
  String _searchQuery = '';
  List<String> kanwilList = [];
  List<String> kotaList = [];

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.20.20.174/fms/api/spk_api/get_all'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        print('Data received: $data'); // Logging

        setState(() {
          agents.clear();
          for (var item in data) {
            try {
              agents.add(
                Agent(
                  idSPK: item['id'] ?? '',
                  is_aktif: item['is_aktif'] ?? '',
                  noSPK: item['no_spk'] ?? '',
                  agentName: item['nama_agen'] ?? '',
                  kota: item['kota'] ?? '',
                  kanwil: item['kanwil'] ?? '',
                  serialNumber: item['serial_number'] ?? '',
                  simCard: item['sim_card'] ?? '',
                  status: item['status'] ?? '',
                  installationDate: DateTime.parse(
                      '${item['tgl_pemasangan']} ${item['jam_pemasangan']}'),
                ),
              );
            } catch (e) {
              print('Error parsing item: $item - $e');
            }
          }
          filteredAgen = agents;
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

  void filterAgents() {
    setState(() {
      filteredAgen = agents.where((agent) {
        final query = _searchQuery.toLowerCase();

        // Pencocokan teks
        final matchesQuery = agent.agentName.toLowerCase().contains(query) ||
            agent.kota.toLowerCase().contains(query) ||
            agent.kanwil.toLowerCase().contains(query) ||
            agent.noSPK.toLowerCase().contains(query) ||
            agent.simCard.toLowerCase().contains(query) ||
            agent.serialNumber.toLowerCase().contains(query) ||
            agent.status.toLowerCase().contains(query);

        // Pencocokan berdasarkan kategori filter
        final matchesKanwil = selectedKanwil == null ||
            selectedKanwil!.isEmpty ||
            agent.kanwil.toLowerCase() == selectedKanwil!.toLowerCase();

        final matchesKota = selectedKota == null ||
            selectedKota!.isEmpty ||
            agent.kota.toLowerCase() == selectedKota!.toLowerCase();

        final matchesStatus = selectedStatus == null ||
            selectedStatus!.isEmpty ||
            selectedStatus == 'semua' ||
            agent.status.toLowerCase() == selectedStatus!.toLowerCase();

        return matchesQuery && matchesKanwil && matchesKota && matchesStatus;
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
    fetchData();
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
              padding: EdgeInsets.all(16.0),
              child: Text(
                'List Agen',
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
                        'SIM CARD',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'STATUS',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'TANGGAL PEMASANGAN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      DataColumn(
                          label: Text(
                        'AKSI',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ],
                    source: AgentDataSource(filteredAgen, context),
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

class AgentDataSource extends DataTableSource {
  final List<Agent> agents;
  final BuildContext context;

  AgentDataSource(this.agents, this.context);

  @override
  DataRow getRow(int index) {
    final Agent agent = agents[index];

    return DataRow(cells: [
      DataCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: agent.is_aktif == '1' ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            agent.is_aktif == '1' ? 'Aktif' : 'Tidak Aktif',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      DataCell(Text(agent.noSPK)),
      DataCell(Text(agent.agentName)),
      DataCell(Text(agent.kota)),
      DataCell(Text(agent.kanwil)),
      DataCell(Text(agent.serialNumber)),
      DataCell(Text(agent.simCard)),
      DataCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: agent.is_aktif == '1' ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            agent.is_aktif == '1' ? 'Sudah Pasang' : 'Belum Pasang',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID').format(agent.installationDate),
          ),
          Text(
            DateFormat('HH:mm:ss').format(agent.installationDate),
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
                  builder: (context) => DetailPage(
                    // id: agent.idSPK ?? 'defaultID',
                    userData: null,
                    id: agent.idSPK ?? 'id',
                  ),
                ),
              );
            } else if (value == 'Edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAgen(
                    id: agent.idSPK,
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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => agents.length;

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

Color _getStatusText(String status, String is_aktif) {
  if ((status == 'Belum Registrasi' || status == 'Belum Pasang') &&
      is_aktif == '1') {
    return Colors.red;
  } else if (status == 'Sudah Pasang' && is_aktif == '1') {
    return Colors.green;
  } else {
    return Colors.transparent;
  }
}
