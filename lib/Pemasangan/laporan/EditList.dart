import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pola/Pemasangan/LaporanPemasangan.dart';
import 'dart:convert';
import '../../user/User.dart';

class EditList extends StatefulWidget {
  final String? id;
  final String? noSpk;
  final String? namaAgen;
  final String? alamatAgen;
  final String? teleponAgen;
  final String? serialNumber;
  final String? tid;
  final String? mid;
  final String? kota;
  final String? idKanwil;
  final String? status;
  final String? catatan;
  final User? userData;

  const EditList({
    Key? key,
    this.id,
    this.noSpk,
    this.namaAgen,
    this.alamatAgen,
    this.teleponAgen,
    this.serialNumber,
    this.tid,
    this.mid,
    this.kota,
    this.idKanwil,
    this.status,
    this.catatan,
    required this.userData,
  }) : super(key: key);

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _noSpkController;
  late TextEditingController _namaAgenController;
  late TextEditingController _alamatAgenController;
  late TextEditingController _teleponAgenController;
  late TextEditingController _serialNumberController;
  late TextEditingController _tidController;
  late TextEditingController _midController;
  late TextEditingController _catatanController;
  String? _selectedKota;
  String? _selectedKanwil;
  String? _selectedStatus = 'semua';
  List<String> kanwilList = [];
  List<String> kotaList = [];

  @override
  void initState() {
    super.initState();
    _noSpkController = TextEditingController(text: widget.noSpk ?? '');
    _namaAgenController = TextEditingController(text: widget.namaAgen ?? '');
    _alamatAgenController =
        TextEditingController(text: widget.alamatAgen ?? '');
    _teleponAgenController =
        TextEditingController(text: widget.teleponAgen ?? '');
    _serialNumberController =
        TextEditingController(text: widget.serialNumber ?? '');
    _tidController = TextEditingController(text: widget.tid ?? '');
    _midController = TextEditingController(text: widget.mid ?? '');
    _selectedStatus = widget.status ?? 'semua';
    _catatanController = TextEditingController(text: widget.catatan ?? '');
    _selectedKota = widget.kota ?? 'Pilih Kota';
    _selectedKanwil = widget.idKanwil ?? 'Pilih Kanwil';

    fetchKanwilList();
    fetchKotaList();
    fetchPemasanganById(widget.id ?? '');
  }

  void dispose() {
    // Dispose all controllers
    _noSpkController.dispose();
    _namaAgenController.dispose();
    _alamatAgenController.dispose();
    _teleponAgenController.dispose();
    _serialNumberController.dispose();
    _tidController.dispose();
    _midController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> fetchPemasanganById(String id) async {
    final url =
        Uri.parse('http://192.168.50.69/pola/api/pemasangan_api/show/$id');
    final response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data']['data'];

        setState(() {
          _noSpkController.text = data['no_spk'] ?? '';
          _namaAgenController.text = data['nama_agen'] ?? '';
          _alamatAgenController.text = data['alamat_agen'] ?? '';
          _teleponAgenController.text = data['telepon_agen'] ?? '';
          _serialNumberController.text = data['serial_number'] ?? '';
          _tidController.text = data['tid'] ?? '';
          _midController.text = data['mid'] ?? '';
          _selectedKota = data['kota'] ?? 'Pilih Kota';
          _selectedKanwil = data['kanwil'] ?? 'Pilih Kanwil';
          _selectedStatus = data['status_pemasangan'] ?? 'Status';
          _catatanController.text = data['catatan_pemasangan'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(jsonResponse['msg'] ?? 'Failed to fetch data.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch data.')),
      );
    }
  }

  Future<void> update() async {
    if (_formKey.currentState!.validate()) {
      // final url = Uri.parse('http://10.20.20.174/fms/api/pemasangan_api/update');
      // final response = await http.post(
      //   url,
      //   body: {
      //     'id': widget.id ?? ''
      //   },
      // );
      final response = await http.post(
        Uri.parse('http://192.168.50.69/pola/api/pemasangan_api/update'),
        body: {
          'id': widget.id ?? '',
          'serial_number_lama': widget.serialNumber ?? '',
          'serial_number_baru': _serialNumberController.text.isNotEmpty
              ? _serialNumberController.text
              : '',
          'status_pemasangan': _selectedStatus ?? '',
          'catatan_pemasangan':
              _catatanController.text.isNotEmpty ? _catatanController.text : '',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Data Pemasangan berhasil diperbarui'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LaporanPemasangan(userData: widget.userData),
                        ),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Gagal'),
                content: Text(jsonResponse['msg']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Gagal'),
              content: const Text('Gagal memperbarui data'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LaporanPemasangan(userData: widget.userData),
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
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit List Pemasangan',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Nomor JO'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _noSpkController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor JO is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Nama Agen'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _namaAgenController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama Agen is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Alamat Agen'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _alamatAgenController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alamat Agen is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Telepon Agen'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _teleponAgenController,
                          decoration: const InputDecoration(
                            prefixText: '+62 ',
                            prefixStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Telepon Agen is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Serial Number'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _serialNumberController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Serial Number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('TID'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _tidController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'TID is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('MID'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _midController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'MID is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text('Kota'),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: kotaList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 135.0),
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
                              _selectedKota = value;
                            });
                          },
                          value: kotaList.contains(_selectedKota)
                              ? _selectedKota
                              : null,
                        ),
                        const SizedBox(height: 15),
                        const Text('Kanwil'),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
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
                              _selectedKanwil = value;
                            });
                          },
                          value: kanwilList.contains(_selectedKanwil)
                              ? _selectedKanwil
                              : null,
                        ),
                        const SizedBox(height: 15),
                        const Text('Status'),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: [
                            'semua',
                            'done',
                            'on progress',
                            'pending',
                            'failed'
                          ].contains(_selectedStatus)
                              ? _selectedStatus
                              : 'semua', // Atau null untuk tidak ada pilihan awal
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
                              _selectedStatus = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('Catatan Pemasangan'),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _catatanController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color.fromARGB(255, 233, 231, 231)),
                                minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(100, 50)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LaporanPemasangan(
                                        userData: widget.userData),
                                  ),
                                );
                              },
                              child: const Text(
                                'Tutup',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.blue),
                                minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(100, 50)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: update,
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
