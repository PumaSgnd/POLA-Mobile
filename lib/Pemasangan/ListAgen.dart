import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:pola/Pemasangan/listagen/DetailAgen.dart';
import 'package:pola/Pemasangan/listagen/EditAgen.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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

  // Future<void> fetchData() async {
  //   final response =
  //       await http.get(Uri.parse('http://localhost/fms/api/spk_api/get_all'));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     final List<dynamic> data = jsonResponse['data'];

  //     setState(() {
  //       agents.clear();
  //       for (var item in data) {
  //         agents.add(Agent(
  //           is_aktif: item['is_aktif'],
  //           agentName: item['nama_agen'],
  //           kanwil: item['kanwil'],
  //           serialNumber: item['serial_number'],
  //           status: item['status'],
  //           installationDate: DateTime.parse(item['tgl_pemasangan']),
  //         ));
  //       }
  //     });
  //     print(data);
  //   } else {
  //     throw Exception('Gagal mengambil data dari API');
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData(); // Panggil fungsi fetchData saat halaman dibuat
  // }

  Future<void> fetchData() async {
    try {
      // Dummy data for testing
      final List<Map<String, dynamic>> dummyData = [
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 1',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        {
          'is_aktif': '1',
          'no_spk': 'SPK001',
          'nama_agen': 'Agen 2',
          'kota': 'pku',
          'kanwil': 'Kanwil 1',
          'serialnumber': 'SN001',
          'sim_card': 'SIM001',
          'status': 'Sudah Pasang',
          'tgl_pemasangan': '2023-07-02',
          'jam_pemasangan': '10:00:00',
        },
        // Add more data as needed
      ];

      List<Agent> tempAgents = dummyData.map((item) {
        return Agent(
          is_aktif: item['is_aktif'],
          noSPK: item['no_spk'],
          agentName: item['nama_agen'],
          kota: item['kota'],
          kanwil: item['kanwil'],
          serialNumber: item['serialnumber'],
          simCard: item['sim_card'],
          status: item['status'],
          installationDate: DateTime.parse(
              '${item['tgl_pemasangan']} ${item['jam_pemasangan']}'),
        );
      }).toList();

      setState(() {
        agents = tempAgents;

        // Apply search filter
        filteredAgen = agents.where((agent) {
          final searchLower = _searchQuery.toLowerCase();
          return agent.noSPK.toLowerCase().contains(searchLower) ||
              agent.agentName.toLowerCase().contains(searchLower) ||
              agent.kota.toLowerCase().contains(searchLower) ||
              agent.kanwil.toLowerCase().contains(searchLower) ||
              agent.serialNumber.toLowerCase().contains(searchLower);
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
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                  builder: (context) => const DetailPage(detailId: '', userData: null,),
                ),
              );
            } else if (value == 'Edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditAgen(userData: null,),
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
