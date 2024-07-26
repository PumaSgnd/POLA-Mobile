// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
//Menu
import '../Menu/MenuDrop.dart';
import '../user/User.dart';

class InputWDEDC extends StatefulWidget {
  static const String id = "/InputWDEDC";
  final User? userData;
  const InputWDEDC({Key? key, required this.userData}) : super(key: key);
  @override
  _InputWDEDCState createState() => _InputWDEDCState();
}

class _InputWDEDCState extends State<InputWDEDC> {
  final TextEditingController nomorJoController = TextEditingController();
  final TextEditingController namaAgenController = TextEditingController();
  final TextEditingController alamatAgenController = TextEditingController();
  final TextEditingController teleponAgenController = TextEditingController();
  final TextEditingController tidController = TextEditingController();
  final TextEditingController midController = TextEditingController();
  String selectedKota = 'Pilih Kota';
  String selectedKanwil = 'Pilih Kanwil';
  DateTime selectedDate = DateTime.now();
  String selectedFile = '';

  List<String> kotaList = [];
  List<String> kanwilList = [];

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single.path!;
      });
    }
  }

  String? _fileName;

  bool dataFetched = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Input JO Penarikan',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Nomor JO Penarikan'),
                          SizedBox(width: 5),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: nomorJoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor JO Penarikan wajib diisi';
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
                        controller: namaAgenController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama Agen wajib diisi';
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
                        controller: alamatAgenController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Alamat Agen wajib diisi';
                          }
                          return null;
                        },
                        enabled: false,
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: teleponAgenController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                prefixText: '+62 ',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Telepon Agen wajib diisi';
                                }
                                return null;
                              },
                              enabled: false,
                            ),
                          ),
                        ],
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
                        controller: tidController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'TID wajib diisi';
                          }
                          return null;
                        },
                        enabled: false,
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
                        controller: midController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'MID wajib diisi';
                          }
                          return null;
                        },
                        enabled: false,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _selectFile();
                                  if (selectedFile.isNotEmpty) {
                                    setState(() {
                                      _fileName = selectedFile.split('/').last;
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all<Size>(
                                      const Size(100, 60)),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Pilih File',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(path.basename(
                                  _fileName ?? "Tidak ada file yang diunggah")),
                            ),
                          ],
                        ),
                      ),
                      if (_fileName == null || _fileName!.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Jenis file xlsx. Ukuran file maksimal 2 MB',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
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
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
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
    );
  }
}
