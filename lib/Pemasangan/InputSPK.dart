import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
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
  String? selectedKota;
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
    initializeDateFormatting('id_ID', null).then((_) {});
    fetchKotaList();
    fetchKanwilList().then((_) {
      setState(() {
        dataFetched = true;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
            selectedDate.second,
          );
        });
      }
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

  void sendHttpRequestWithBody() async {
    final String baseUrl = "http://10.20.20.195/fms/api/spk_api/save";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.fields['no_spk'] = nomorJoController.text;
      request.fields['nama_agen'] = namaAgenController.text;
      request.fields['alamat_agen'] = alamatAgenController.text;
      request.fields['telepon_agen'] = teleponAgenController.text;
      request.fields['kota'] = selectedKota!;
      if (selectedKanwil != null && selectedKanwil.contains(':')) {
        final parts = selectedKanwil.split(':');
        final idKanwil = parts[0];
        request.fields['id_kanwil'] = idKanwil;
      }
      request.fields['tid'] = tidController.text;
      request.fields['mid'] = midController.text;
      request.fields['tanggal'] =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate);
      request.fields['created_by'] = widget.userData!.username;

      print(request.fields['created_by']);
      // print('Username: ${widget.userData!.username}');

      print('namaaaaaaaa' + selectedFile);
      if (selectedFile.isNotEmpty) {
        var file = File(selectedFile);
        var fileName = path.basename(file.path);

        print('nama file' + fileName);
        request.files.add(
          http.MultipartFile(
            'dok_spk',
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
          print('SPK berhasil disimpan');
        } else {
          print('SPK gagal disimpan: ${responseData['err_msg']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> fetchKotaList() async {
    final String baseUrl = "http://10.20.20.195/fms/api/kota_api/kota_get_all";

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> kotaData = responseData['data'];
          kotaList = kotaData.map<String>((item) {
            return "${item['city_name']}";
          }).toList();
        } else {
          print("Error fetching Kanwil data");
        }
        print('Kota data: $kotaList');
      } else {
        print("Error fetching Kota data");
      }
    } catch (error) {
      print('An error occurred while fetching Kota data: $error');
    }
  }

  Future<void> fetchKanwilList() async {
    final String apiUrl = "http://10.20.20.195/fms/api/kanwil_api/get_all";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> kanwilData = responseData['data'];
          kanwilList = kanwilData.map<String>((item) {
            final String id = item['id'].toString();
            final String nama = item['nama'];
            return "$id:$nama";
          }).toList();
        } else {
          print("Error fetching Kanwil data");
        }
        print('Kanwil data: $kanwilList');
      } else if (response.statusCode == 404) {
        final errorData = json.decode(response.body);
        print("Error fetching Kanwil data: ${errorData['message']}");
      } else {
        print("Error fetching Kanwil data");
      }
    } catch (error) {
      print('An error occurred while fetching Kanwil data: $error');
    }
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
                          controller: nomorJoController,
                          decoration: const InputDecoration(
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
                        const SizedBox(height: 5.0),
                        Container(
                          height: 55,
                          child: TextFormField(
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
                        const SizedBox(height: 5.0),
                        Container(
                          child: TextFormField(
                            controller: alamatAgenController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal:
                                      12.0), // Ubah ukuran padding di sini
                            ),
                            maxLines: null,
                            minLines: 1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Alamat Agen wajib diisi';
                              }
                              return null;
                            },
                          ),
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
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 20, left: 10),
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
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Pilih Kota'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.dialog(
                              showSelectedItems: true,
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                              ),
                              dialogProps: DialogProps(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            items: [
                              'Pilih Kota',
                              ...kotaList,
                            ], // Include placeholder in the items list
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Pilih Kota",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null &&
                                  newValue != 'Pilih Kota') {
                                setState(() {
                                  selectedKota = newValue;
                                });
                              } else {
                                setState(() {
                                  selectedKota = null;
                                });
                              }
                            },
                            selectedItem: selectedKota ?? 'Pilih Kota',
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Pilih Kanwil'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
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
                                    child: Text(
                                      namaKanwil ?? '',
                                      style: TextStyle(
                                        fontWeight: value == 'Pilih Kanwil'
                                            ? FontWeight.normal
                                            : FontWeight.normal,
                                        color: value == 'Pilih Kanwil'
                                            ? Colors.black
                                            : Colors
                                                .black, // Optional: Different color for the placeholder
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Tanggal'),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Dokumen JO'),
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
                                sendHttpRequestWithBody();
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
