// ignore_for_file: file_names, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
//Menu
import '../Menu/MenuPemasangan.dart';
import '../user/User.dart';

class Pemasangan extends StatefulWidget {
  static const String id = "/PemasanganBaru";
  final User? userData;
  const Pemasangan({Key? key, required this.userData}) : super(key: key);
  @override
  _PemasanganState createState() => _PemasanganState();

  int getCount() {
    // Replace this with the actual logic to get the count value for Pemasangan
    return 0;
  }
}

class _PemasanganState extends State<Pemasangan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaAgenController = TextEditingController();
  // final TextEditingController _teleponAgenController = TextEditingController();
  TextEditingController _spkController = TextEditingController();
  List<Map<String, dynamic>> suggestionList = [];
  String? id_spk = "";
  String? kanwil = "";
  String tid = '';
  String serialNumber = '';
  String? teleponAgen = '';
  String? alamatAgen = "";
  String _latitude = '';
  String _longitude = '';
  List<String> suggestions = [];
  String selectedNamaAgen = "";
  File? _pemasanganFoto;
  File? _agenPerangkatFoto;
  File? _tempatFoto;
  File? _bannerFoto;
  File? _fotoTransaksiTunai;
  File? _fotoTransaksiDebit;
  File? _fotoTransaksiAntarBank;
  String? _selectedStatus;
  String? catatan = " ";
  GoogleMapController? _mapController;
  late CameraPosition _initialCameraPosition;
  Set<Marker> _markers = {};
  bool isBoxVisible = false;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = const CameraPosition(
      target: LatLng(-6.200000, 106.816666),
      zoom: 15,
    );
    _namaAgenController.addListener(_onNamaAgenChanged);
    id_spk = '';
    alamatAgen = '';
    tid = '';
    serialNumber = '';
    teleponAgen = '';
    kanwil = '';
  }

  @override
  void dispose() {
    _namaAgenController.dispose();
    super.dispose();
  }

  void _onNamaAgenChanged() {
    final value = _namaAgenController.text;
    setState(() {
      isBoxVisible = value.isNotEmpty;
    });
  }

  String truncateFileName(String fileName, {int maxLength = 15}) {
    if (fileName.isEmpty || fileName.length <= maxLength) {
      return fileName;
    } else {
      return '${fileName.substring(0, maxLength)}...';
    }
  }

  Future<void> _fetchAgentData(String keyword) async {
    final Uri uri = Uri.parse(
      'http://192.168.50.69/pola/api/pemasangan_api/find_by_agen_pemasangan?nama_agen=$keyword',
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
                tid = suggestionMap['tid'] ?? '';
                id_spk = suggestionMap['spk'];
                _spkController.text = id_spk!;
                kanwil = suggestionMap['id_kanwil'] ?? '';
                serialNumber = suggestionMap['serial_number'] ?? '';
                teleponAgen = suggestionMap['telepon_agen'] ?? '';
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

  Future<void> _capturePemasanganFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _pemasanganFoto = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureAgenPerangkatFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _agenPerangkatFoto = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureFotoBanner() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _bannerFoto = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureFotoTempat() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _tempatFoto = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureTransaksiTunai() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _fotoTransaksiTunai = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureTransaksiDebit() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _fotoTransaksiDebit = File(pickedFile.path);
      }
    });
  }

  Future<void> _captureTransaksiAntarBank() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _fotoTransaksiAntarBank = File(pickedFile.path);
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _latitude = _locationData.latitude.toString();
      _longitude = _locationData.longitude.toString();
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_locationData.latitude!, _locationData.longitude!),
        ),
      );
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("Lokasi Saat Ini"),
          position: LatLng(_locationData.latitude!, _locationData.longitude!),
          infoWindow: const InfoWindow(title: "Lokasi Anda"),
        ),
      );
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("Lokasi Saat Ini"),
          position: position,
          infoWindow: const InfoWindow(title: "Lokasi Anda"),
        ),
      );
    });
  }

  Future<void> submitForm(BuildContext context) async {
    // if (_formKey.currentState!.validate()) {

    _formKey.currentState!.save();
    try {
      final uri =
          Uri.parse("http://192.168.50.69/pola/api/pemasangan_api/save");
      var request = http.MultipartRequest("POST", uri);

      // Add form fields
      request.fields['id_spk'] = id_spk ?? '';
      request.fields['nama_agen'] = _namaAgenController.text;
      request.fields['serial_number'] = serialNumber ?? '';
      request.fields['tid'] = tid ?? '';
      request.fields['alamat_agen'] = alamatAgen ?? '';
      request.fields['telepon_agen'] = teleponAgen ?? '';
      request.fields['longitude'] = _longitude;
      request.fields['latitude'] = _latitude;
      request.fields['catatan'] = catatan ?? '';
      request.fields['status'] = _selectedStatus ?? '';

      // Add the images
      await _addImageToRequest(request, 'foto_pemasangan', _pemasanganFoto);
      await _addImageToRequest(request, 'foto_agen', _agenPerangkatFoto);
      await _addImageToRequest(request, 'foto_tempat', _tempatFoto);
      await _addImageToRequest(request, 'foto_banner', _bannerFoto);
      await _addImageToRequest(request, 'foto_transaksi1', _fotoTransaksiTunai);
      await _addImageToRequest(request, 'foto_transaksi2', _fotoTransaksiDebit);
      await _addImageToRequest(
          request, 'foto_transaksi3', _fotoTransaksiAntarBank);

      // Send the request
      var response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var responseData = json.decode(responseString);

        if (responseData['success'] == true) {
          showAlertDialog(
              context, 'Success', 'Data Pemasangan berhasil disimpan');
        } else {
          showAlertDialog(context, 'Failure',
              'Data Pemasangan gagal disimpan: ${responseData['err_msg']}');
        }
      } else {
        showAlertDialog(context, 'Error',
            'Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      showAlertDialog(context, 'Error', 'An error occurred: $error');
    }
    // } else {
    //   print('Form validation failed.');
    // }
  }

  Future<void> _addImageToRequest(
      http.MultipartRequest request, String fieldName, File? image) async {
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        image.path,
        filename: basename(image.path),
      ));
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context as BuildContext,
                  MaterialPageRoute(
                    builder: (context) => Pemasangan(userData: widget.userData),
                  ),
                );
              },
              child: Text("OK"),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pasang Baru',
                    style: TextStyle(
                      fontSize: 20,
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
                            Text('Nama Agen'),
                            SizedBox(width: 5),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: _namaAgenController,
                            onChanged: (value) async {
                              setState(() {
                                isBoxVisible = value.isNotEmpty;
                              });
                              if (value.isNotEmpty) {
                                await _fetchAgentData(value);
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isBoxVisible,
                          child: Container(
                            height:
                                50, // Atur tinggi Container sesuai kebutuhan
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
                                    final selectedSuggestion =
                                        suggestions[index];
                                    final suggestionMap =
                                        suggestionList.firstWhere(
                                      (suggestion) =>
                                          suggestion['value'] ==
                                          selectedSuggestion,
                                      orElse: () => <String,
                                          dynamic>{}, // Return empty map
                                    );

                                    if (suggestionMap.isNotEmpty) {
                                      setState(() {
                                        selectedNamaAgen = selectedSuggestion;
                                        _namaAgenController.text =
                                            selectedSuggestion;
                                        id_spk = suggestionMap['spk'];
                                        _spkController.text = id_spk!;
                                        serialNumber =
                                            suggestionMap['serial_number'] ??
                                                '';
                                        alamatAgen =
                                            suggestionMap['alamat'] ?? '';
                                        tid = suggestionMap['tid'] ?? '';
                                        teleponAgen =
                                            suggestionMap['telepon_agen'] ?? '';
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
                        Offstage(
                          offstage: true, // Hide this widget from the UI
                          child: TextFormField(
                            controller: _spkController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field ini wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          controller: TextEditingController(text: serialNumber),
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Serial Number wajib diisi';
                            }
                            return null;
                          },
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
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
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'TID wajib diisi';
                            }
                            return null;
                          },
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
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
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Alamat Agen wajib diisi';
                            }
                            return null;
                          },
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
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
                          controller: TextEditingController(text: teleponAgen),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.green),
                                minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(100, 50)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: _getCurrentLocation,
                              child: const Text(
                                'Ambil Koordinat',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Longitude: $_longitude'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Latitude: $_latitude'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: _initialCameraPosition,
                            markers: _markers,
                            onTap: _onMapTap,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Foto Pemasangan'),
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
                                      onPressed: _capturePemasanganFoto,
                                      child: const Text(
                                        'Pilih File',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _pemasanganFoto != null
                                          ? Text(
                                              truncateFileName(path.basename(
                                                  _pemasanganFoto!.path)),
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
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Foto Agen & Perangkat'),
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
                                      onPressed: _captureAgenPerangkatFoto,
                                      child: const Text(
                                        'Pilih File',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _agenPerangkatFoto != null
                                          ? Text(
                                              truncateFileName(path.basename(
                                                  _agenPerangkatFoto!.path)),
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
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Foto Banner'),
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
                                      onPressed: _captureFotoBanner,
                                      child: const Text(
                                        'Pilih File',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _bannerFoto != null
                                          ? Text(
                                              truncateFileName(path
                                                  .basename(_bannerFoto!.path)),
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
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Foto Tempat'),
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
                                      onPressed: _captureFotoTempat,
                                      child: const Text(
                                        'Pilih File',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _tempatFoto != null
                                          ? Text(
                                              truncateFileName(path
                                                  .basename(_tempatFoto!.path)),
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
                        const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Foto Transaksi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Foto Transaksi Tunai'),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: _captureTransaksiTunai,
                                            child: const Text(
                                              'Pilih File',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _fotoTransaksiTunai != null
                                                ? Text(
                                                    truncateFileName(
                                                        path.basename(
                                                            _fotoTransaksiTunai!
                                                                .path)),
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Foto Transaksi Debit'),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: _captureTransaksiDebit,
                                            child: const Text(
                                              'Pilih File',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _fotoTransaksiDebit != null
                                                ? Text(
                                                    truncateFileName(
                                                        path.basename(
                                                            _fotoTransaksiDebit!
                                                                .path)),
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Foto Transaksi Antar Bank'),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed:
                                                _captureTransaksiAntarBank,
                                            child: const Text(
                                              'Pilih File',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _fotoTransaksiAntarBank !=
                                                    null
                                                ? Text(
                                                    truncateFileName(path.basename(
                                                        _fotoTransaksiAntarBank!
                                                            .path)),
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text('Status'),
                                SizedBox(width: 5),
                                Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 16.0,
                                ),
                              ),
                              value: _selectedStatus,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 'done',
                                  child: Text('Done'),
                                ),
                                DropdownMenuItem(
                                  value: 'onprogress',
                                  child: Text('On Progress'),
                                ),
                                DropdownMenuItem(
                                  value: 'pending',
                                  child: Text('Pending'),
                                ),
                                DropdownMenuItem(
                                  value: 'failed',
                                  child: Text('Failed'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a status';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Catatan'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          height: 96.0,
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    catatan = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                submitForm(context);
                              },
                              child: const Text('Simpan',
                                  style: TextStyle(color: Colors.white)),
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

  String getSerialNumberFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('serialnumber')) {
            return suggestionMap['serialnumber'];
          } else {
            print('Data "serialnumber" tidak ditemukan dalam JSON saran.');
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
            print('Data "teleponAgen" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }
    return '';
  }

  String getspkFromDatabase(String? namaAgen) {
    if (namaAgen != null) {
      final suggestion = suggestions.firstWhere(
        (suggestion) => suggestion == namaAgen,
        orElse: () => '',
      );

      if (suggestion.isNotEmpty) {
        try {
          final Map<String, dynamic> suggestionMap = json.decode(suggestion);

          if (suggestionMap.containsKey('id_spk')) {
            return suggestionMap['id_spk'];
          } else {
            print('Data "spk" tidak ditemukan dalam JSON saran.');
          }
        } catch (e) {
          print('Gagal mengurai JSON: $e');
        }
      }
    }
    return '';
  }
}
