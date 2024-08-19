import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pola/Pemasangan/ListAgen.dart';
import '../../user/User.dart';

class EditAgen extends StatefulWidget {
  final String? id;
  final String? noSpk;
  final String? namaAgen;
  final String? alamatAgen;
  final String? teleponAgen;
  final String? tid;
  final String? mid;
  final String? kota;
  final String? idKanwil;
  final User? userData;

  const EditAgen({
    Key? key,
    this.id,
    this.noSpk,
    this.namaAgen,
    this.alamatAgen,
    this.teleponAgen,
    this.tid,
    this.mid,
    this.kota,
    this.idKanwil,
    required this.userData,
  }) : super(key: key);

  @override
  _EditAgenState createState() => _EditAgenState();
}

class _EditAgenState extends State<EditAgen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _noSpkController;
  late TextEditingController _namaAgenController;
  late TextEditingController _alamatAgenController;
  late TextEditingController _teleponAgenController;
  late TextEditingController _tidController;
  late TextEditingController _midController;
  String? _selectedKota;
  String? _selectedKanwil;
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
    _tidController = TextEditingController(text: widget.tid ?? '');
    _midController = TextEditingController(text: widget.mid ?? '');
    _selectedKota = widget.kota ?? 'Pilih Kota';
    _selectedKanwil = widget.idKanwil ?? 'Pilih Kanwil';
    _fetchAgenData(widget.id ?? '');
    fetchKanwilList();
    fetchKotaList();
  }

  @override
  void dispose() {
    _noSpkController.dispose();
    _namaAgenController.dispose();
    _alamatAgenController.dispose();
    _teleponAgenController.dispose();
    _tidController.dispose();
    _midController.dispose();
    super.dispose();
  }

  Future<void> _fetchAgenData(String id) async {
    final url = Uri.parse('http://10.20.20.174/fms/api/spk_api/show/$id');
    http.Response response = await http.get(url);

    print(id);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        setState(() {
          // Mengisi controller dengan data yang diterima
          _noSpkController.text = data['data']['no_spk'] ?? '';
          _namaAgenController.text = data['data']['nama_agen'] ?? '';
          _alamatAgenController.text = data['data']['alamat_agen'] ?? '';
          _teleponAgenController.text = data['data']['telepon_agen'] ?? '';
          _tidController.text = data['data']['tid'] ?? '';
          _midController.text = data['data']['mid'] ?? '';
          _selectedKota = data['data']['kota'] ?? 'Pilih Kota';
          _selectedKanwil = data['data']['kanwil'] ?? 'Pilih Kanwil';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch data.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch data.')),
      );
    }
  }

  Future<void> _updateAgen() async {
    final url = Uri.parse('http://10.20.20.174/fms/api/spk_api/update');
    final response = await http.post(
      url,
      body: {
        'id': widget.id,
        'no_spk': _noSpkController.text,
        'nama_agen': _namaAgenController.text,
        'alamat_agen': _alamatAgenController.text,
        'telepon_agen': _teleponAgenController.text,
        'kota': _selectedKota,
        'kanwil': _selectedKanwil,
        'tid': _tidController.text,
        'mid': _midController.text,
      },
    );
    print(widget.id);
    print('Response body: ' + response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['success'] ? 'Success' : 'Error'),
            content: Text(result['msg']),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAgen(userData: widget.userData),
                    ),
                  );
                },
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
            title: const Text('Error'),
            content: const Text('Failed to update data.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAgen(userData: widget.userData),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      _updateAgen();
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListAgen(userData: widget.userData),
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
                    'Edit List Agen',
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
                            Text('NOMOR JO'),
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
                            Text('AGEN'),
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
                            Text('ALAMAT AGEN'),
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
                            Text('TELEPON AGEN'),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('KOTA'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('KANWIL'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 233, 231, 231)),
                          minimumSize: WidgetStateProperty.all<Size>(
                              const Size(100, 50)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListAgen(userData: widget.userData),
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: _save,
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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
