import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
//Menu
import '../Menu/MenuPemasangan.dart';
import '../user/User.dart';

class InputSPK extends StatefulWidget {
  static const String id = "/InputSPK";
  final User? userData;
  const InputSPK({Key? key, required this.userData}) : super(key: key);
  @override
  _InputSPKState createState() => _InputSPKState();
}

class _InputSPKState extends State<InputSPK> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {});
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
        builder: (context) => MenuPemasangan(userData: widget.userData),
      ),
    );
    return false;
  }

  String? validateDropdown(String? value, String defaultValue) {
    if (value == null || value == defaultValue) {
      return '$defaultValue wajib dipilih';
    }
    return null;
  }

  String? validateFile(String? value) {
    if (value == null || value.isEmpty) {
      return 'File wajib diunggah';
    }
    return null;
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Input JO',
                    style: TextStyle(
                      fontSize: 20.0,
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
                        TextFormField(
                          controller: nomorJoController,
                          decoration: const InputDecoration(
                            labelText: 'Nomor JO',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nomor JO wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: namaAgenController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Agen',
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
                        TextFormField(
                          controller: alamatAgenController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat Agen',
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
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: teleponAgenController,
                                decoration: const InputDecoration(
                                  labelText: 'Telepon Agen',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  prefixText: '+62 ',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Telepon Agen wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: tidController,
                          decoration: const InputDecoration(
                            labelText: 'TID',
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
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: midController,
                          decoration: const InputDecoration(
                            labelText: 'MID',
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
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String?>(
                              value: selectedKota,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedKota = newValue!;
                                });
                              },
                              items: <String?>[
                                'Pilih Kota',
                                ...kotaList
                              ].map<DropdownMenuItem<String?>>((String? value) {
                                return DropdownMenuItem<String?>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(value ?? ''),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: 'Pilih Kota',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              isDense: true,
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String?>(
                              value: selectedKanwil,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedKanwil = newValue!;
                                });
                              },
                              items: <String?>[
                                'Pilih Kanwil',
                                ...kanwilList
                              ].map<DropdownMenuItem<String?>>((String? value) {
                                final parts = value?.split(':');
                                final namaKanwil =
                                    parts != null && parts.length == 2
                                        ? parts[1].toUpperCase()
                                        : value;
                                return DropdownMenuItem<String?>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(namaKanwil ?? ''),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: 'Pilih Kanwil',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              isDense: true,
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Tanggal :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('dd MMMM yyyy', 'id_ID')
                                            .format(selectedDate),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _selectDate(context),
                                  child: const Text(
                                    "Ubah Tanggal",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _selectFile();
                                    if (selectedFile.isNotEmpty) {
                                      setState(() {
                                        _fileName =
                                            selectedFile.split('/').last;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all<Size>(
                                        const Size(100, 55)),
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
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(path.basename(_fileName ??
                                    "Tidak ada file yang diunggah")),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _fileName != null &&
                                    _fileName!.isNotEmpty) {
                                  // Simpan data
                                } else if (_fileName == null ||
                                    _fileName!.isEmpty) {
                                  setState(() {});
                                }
                              },
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
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
