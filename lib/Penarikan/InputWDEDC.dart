// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomorJoController = TextEditingController();
  final TextEditingController namaAgenController = TextEditingController();
  String id_spk = '';
  String selectedFile = '';
  String serialNumber = " ";
  String tid = " ";
  String mid = " ";
  String selectedNamaAgen = "";
  String? alamatAgen = " ";
  String? teleponAgen = " ";
  String? namaAgen;
  List<String> suggestions = [];
  List<Map<String, dynamic>> suggestionList = [];
  bool isBoxVisible = false;

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
    alamatAgen = '';
    tid = '';
    namaAgenController.addListener(_onNamaAgenChanged);
  }

  void _onNamaAgenChanged() {
    final value = namaAgenController.text;
    setState(() {
      isBoxVisible = value.isNotEmpty;
    });
  }

  @override
  void dispose() {
    namaAgenController.dispose();
    super.dispose();
  }

  void sendHttpRequestWithBody() async {
    final String baseUrl = "http://10.20.20.195/fms/api/panarikan_api/simpan";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.fields['no_spk_penarikan'] = nomorJoController.text ?? '';
      request.fields['id_spk'] = id_spk ?? '';

      if (widget.userData != null) {
        request.fields['created_by'] = widget.userData!.username;
      } else {
        // Handle the case when userData is null
        print('User data is null');
        return;
      }

      if (selectedFile.isNotEmpty) {
        var file = File(selectedFile);
        var fileName = path.basename(file.path);
        request.files.add(
          http.MultipartFile(
            'dok_spk_penarikan',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: fileName,
          ),
        );
      }

      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print('Response body: $responseString');

      if (response.statusCode == 200) {
        var responseData = json.decode(responseString);
        if (responseData['success'] == true) {
          print('JO Penarikan berhasil disimpan');
        } else {
          print('JO Penarikan gagal disimpan: ${responseData['err_msg']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> fetchAgenSuggestions(String keyword) async {
    final Uri uri = Uri.parse(
      'http://10.20.20.195/fms/api/penarikan_api/find_by_agen?nama_agen=$keyword',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData != null && responseData.containsKey('suggestions')) {
          suggestionList =
              List<Map<String, dynamic>>.from(responseData['suggestions']);

          setState(() {
            suggestions = suggestionList
                .map((suggestion) => suggestion['value'].toString())
                .toList();

            if (suggestions.isNotEmpty) {
              final selectedSuggestion = suggestions[0];
              final suggestionMap = suggestionList.firstWhere(
                (suggestion) =>
                    suggestion['value'].toString() == selectedSuggestion,
                orElse: () => <String, dynamic>{},
              );

              if (suggestionMap.isNotEmpty) {
                alamatAgen = suggestionMap['alamat'] ?? '';
                teleponAgen = suggestionMap['telepon_agen'] ?? '';
                tid = suggestionMap['tid'] ?? '';
                mid = suggestionMap['mid'] ?? '';
              }
            }
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
                        onChanged: (value) async {
                          setState(() {
                            isBoxVisible = value.isNotEmpty;
                          });
                          if (value.isNotEmpty) {
                            await fetchAgenSuggestions(value);
                          }
                        },
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
                      Visibility(
                        visible: isBoxVisible,
                        child: Container(
                          height: 50, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListView.builder(
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(suggestions[index]),
                                onTap: () {
                                  final selectedSuggestion = suggestions[index];
                                  final suggestionMap =
                                      suggestionList.firstWhere(
                                    (suggestion) =>
                                        suggestion['value'] ==
                                        selectedSuggestion,
                                    orElse: () =>
                                        <String, dynamic>{}, // Return empty map
                                  );

                                  if (suggestionMap.isNotEmpty) {
                                    setState(() {
                                      selectedNamaAgen = selectedSuggestion;
                                      namaAgenController.text =
                                          selectedSuggestion;
                                      alamatAgen =
                                          suggestionMap['alamat'] ?? '';
                                      teleponAgen =
                                          suggestionMap['telepon_agen'] ?? '';
                                      tid = suggestionMap['tid'] ?? '';
                                      mid = suggestionMap['mid'] ?? '';
                                      isBoxVisible = false;
                                    });
                                  } else {
                                    print('Saran yang dipilih tidak valid.');
                                  }
                                },
                              );
                            },
                          ),
                        ),
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
                        controller: TextEditingController(text: alamatAgen),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
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
                              controller:
                                  TextEditingController(text: teleponAgen),
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
                        controller: TextEditingController(text: tid),
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
                        controller: TextEditingController(text: mid),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Dokumen JO Penarikan'),
                          SizedBox(width: 5),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                            onPressed: () {
                              sendHttpRequestWithBody();
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate() &&
                                  _fileName != null &&
                                  _fileName!.isNotEmpty) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getAlamatAgenFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('alamat')) {
            return suggestionMap['alamat'];
          } else {
            print('Data "alamat" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }

    return '';
  }

  String getTeleponAgenFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('telepon_agen')) {
            return suggestionMap['telepon_agen'];
          } else {
            print('Data "telepon_agen" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }

    return '';
  }

  String getTidFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('tid')) {
            return suggestionMap['tid'];
          } else {
            print('Data "tid" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }

    return '';
  }

  String getMidFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('mid')) {
            return suggestionMap['mid'];
          } else {
            print('Data "mid" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }

    return '';
  }
}
