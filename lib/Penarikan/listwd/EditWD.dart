import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pola/Penarikan/ListWD.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../../user/User.dart';

class EditWD extends StatefulWidget {
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

  const EditWD({
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
  _EditWDState createState() => _EditWDState();
}

class _EditWDState extends State<EditWD> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _noSpkController;
  late TextEditingController _namaAgenController;
  late TextEditingController _alamatAgenController;
  late TextEditingController _teleponAgenController;
  late TextEditingController _tidController;
  late TextEditingController _midController;
  String? _selectedKota;
  String? _selectedKanwil;
  File? _penarikanFoto;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      fetchPenarikanData(widget.id!);
    }
    _noSpkController = TextEditingController(text: widget.noSpk);
    _namaAgenController = TextEditingController(text: widget.namaAgen);
    _alamatAgenController = TextEditingController(text: widget.alamatAgen);
    _teleponAgenController = TextEditingController(text: widget.teleponAgen);
    _tidController = TextEditingController(text: widget.tid);
    _midController = TextEditingController(text: widget.mid);
    _selectedKota = widget.kota;
    _selectedKanwil = widget.idKanwil;
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

  Future<void> _capturePenarikanFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _penarikanFoto = File(pickedFile.path);
      }
    });
  }

  String truncateFileName(String fileName, {int maxLength = 15}) {
    if (fileName.length <= maxLength) {
      return fileName;
    } else {
      return '${fileName.substring(0, maxLength)}...';
    }
  }

  // void _save() {
  //   if (_formKey.currentState!.validate()) {
  //     // Handle save logic here
  //     Navigator.of(context as BuildContext).pop();
  //   }
  // }

  Future<void> fetchPenarikanData(String id) async {
    String url =
        'http://10.20.20.174/fms/api/penarikan_api/show/$id'; // Replace with your actual API endpoint

    print(id);

    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _noSpkController.text = data['data']['no_spk_penarikan'] ?? '';
          _namaAgenController.text = data['data']['nama_agen'] ?? '';
          _alamatAgenController.text = data['data']['alamat_agen'] ?? '';
          _teleponAgenController.text = data['data']['telepon_agen'] ?? '';
          _tidController.text = data['data']['tid'] ?? '';
          _midController.text = data['data']['mid'] ?? '';
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

  Future<void> prosesPenarikan(
      BuildContext context, String id, XFile? imgPenarikan) async {
    String url = 'http://10.20.20.174/fms/api/panarikan_api/proses_penarikan';
    Map<String, dynamic> data = {};

    if (imgPenarikan != null) {
      // Path untuk menyimpan gambar
      Directory appDir = await getApplicationDocumentsDirectory();
      String path = '${appDir.path}/doc/penarikan';

      // Buat directory jika belum ada
      Directory(path).createSync(recursive: true);

      // Konfigurasi dan upload gambar
      String fileName =
          "penarikan_${id}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      File file = await File(imgPenarikan.path).copy('$path/$fileName');
      data['img_penarikan'] = fileName;

      // Konfigurasi multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['edit_id'] = id;
      request.files
          .add(await http.MultipartFile.fromPath('img_penarikan', file.path));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await http.Response.fromStream(response);
          var result = jsonDecode(responseData.body);
          if (result['success']) {
            _showAlertDialog(
                context, 'Sukses', 'Proses Penarikan berhasil diperbarui');
          } else {
            _showAlertDialog(context, 'Gagal',
                'Proses Penarikan gagal diperbarui: ${result['msg']}');
          }
        } else {
          _showAlertDialog(
              context, 'Error', 'Failed to update: ${response.statusCode}');
        }
      } catch (e) {
        _showAlertDialog(context, 'Error', 'Error during request: $e');
      }
    } else {
      _showAlertDialog(context, 'Gagal', 'Image not selected');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context as BuildContext,
      MaterialPageRoute(
        builder: (context) => ListWD(userData: widget.userData),
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
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Proses JO Penarikan',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust border radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.all(20), // Adjust padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Nomor JO Penarikan'),
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                            Text('Foto Penarikan'),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.only(right: 36),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize:
                                            WidgetStateProperty.all<Size>(
                                                const Size(100, 50)),
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
                                      onPressed: _capturePenarikanFoto,
                                      child: const Text(
                                        'Pilih File',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _penarikanFoto != null
                                          ? Text(
                                              truncateFileName(path.basename(
                                                  _penarikanFoto!.path)),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          : const Text(
                                              'Tidak ada file yang dipilih'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Nama Agen'),
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                            prefixText: '+62',
                            alignLabelWithHint: true,
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
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                            SizedBox(
                                width:
                                    5), // Adjust the width as needed for spacing
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
                                    builder: (context) =>
                                        ListWD(userData: widget.userData),
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
                              onPressed: () {
                                prosesPenarikan;
                              },
                              child: const Text(
                                'Proses',
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showEditAgenDialog(
  BuildContext context, {
  String? id,
  String? noSpk,
  String? namaAgen,
  String? alamatAgen,
  String? teleponAgen,
  String? tid,
  String? mid,
  String? kota,
  String? idKanwil,
  required User? userData,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditWD(
        id: id,
        noSpk: noSpk,
        namaAgen: namaAgen,
        alamatAgen: alamatAgen,
        teleponAgen: teleponAgen,
        tid: tid,
        mid: mid,
        kota: kota,
        idKanwil: idKanwil,
        userData: null,
      );
    },
  );
}
