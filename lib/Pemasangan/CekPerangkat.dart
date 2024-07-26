import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:async';
import 'dart:convert';
//Menu
import '../Menu/MenuPemasangan.dart';
import '../user/User.dart';

class CekPerangkat extends StatefulWidget {
  static const String id = "/CekPerangkat";
  final User? userData;
  const CekPerangkat({Key? key, required this.userData}) : super(key: key);
  @override
  _CekPerangkatState createState() => _CekPerangkatState();
}

class _CekPerangkatState extends State<CekPerangkat> {
  String? serialNumber = " ";
  String? tid = " ";
  String? namaAgen;
  List<String> suggestions = [];
  TextEditingController _namaAgenController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  String selectedNamaAgen = "";
  String? alamatAgen = " ";
  String? fungsiPerangkat;
  String _scanBarcode = '';
  String selectedTestFungsi = "";
  String? catatanCekPerangkat = " ";
  List<Map<String, dynamic>> testFungsiItems = [];
  Map<String, String> testFungsi = {};
  bool isBoxVisible = false;

  @override
  void initState() {
    super.initState();
    alamatAgen = '';
    tid = '';
    _namaAgenController.addListener(_onNamaAgenChanged);
  }

  @override
  void dispose() {
    _namaAgenController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  void _onNamaAgenChanged() {
    final value = _namaAgenController.text;
    setState(() {
      isBoxVisible = value.isNotEmpty;
    });
  }

  Future<void> scanBarcodeNormal() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        _scanBarcode = result.rawContent;
        _serialNumberController.text = _scanBarcode;
      });
    } catch (e) {
      setState(() {
        _scanBarcode = 'Failed to get barcode: $e';
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    'Cek Perangkat',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
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
                      const SizedBox(height: 5.0),
                      Container(
                        height: 50,
                        child: TextFormField(
                          controller: _namaAgenController,
                          onChanged: (value) {
                            setState(() {
                              isBoxVisible = value.isNotEmpty;
                            });
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
                          height: 100, // Atur tinggi Container sesuai kebutuhan
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
                                  setState(() {
                                    selectedNamaAgen = suggestions[index];
                                    _namaAgenController.text =
                                        suggestions[index];
                                    isBoxVisible = false;
                                    alamatAgen = getAlamatAgenFromDatabase(
                                        selectedNamaAgen);
                                    tid = getTidFromDatabase(selectedNamaAgen);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
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
                      const SizedBox(height: 5.0),
                      Container(
                        height: 50.0, // Tinggi border
                        child: TextFormField(
                          controller: _serialNumberController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await scanBarcodeNormal();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(100.0, 50.0),
                                  ),
                                ),
                                child: const Text('Scan Barcode',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              serialNumber = value;
                            });
                          },
                          enabled: true,
                        ),
                      ),
                      const SizedBox(height: 15.0),
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
                        height: 50.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          enabled: false,
                          controller: TextEditingController(text: alamatAgen),
                        ),
                      ),
                      const SizedBox(height: 15.0),
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
                      const SizedBox(height: 5.0),
                      Container(
                        height: 50.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          enabled: false,
                          controller: TextEditingController(text: tid),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        height: 97.0,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Fungsi Perangkat'),
                                SizedBox(width: 5),
                                Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('OK'),
                                    value: 'OK',
                                    groupValue: fungsiPerangkat,
                                    onChanged: (value) {
                                      setState(() {
                                        fungsiPerangkat = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('NOK'),
                                    value: 'NOK',
                                    groupValue: fungsiPerangkat,
                                    onChanged: (value) {
                                      setState(() {
                                        fungsiPerangkat = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tes Perangkat',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                                height:
                                    5.0), // Memberi jarak antara tes perangkat dan opsi LCD
                            const Text(
                              '*LCD',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('OK'),
                                    value: 'OK',
                                    groupValue: fungsiPerangkat,
                                    onChanged: (value) {
                                      setState(() {
                                        fungsiPerangkat = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('NOK'),
                                    value: 'NOK',
                                    groupValue: fungsiPerangkat,
                                    onChanged: (value) {
                                      setState(() {
                                        fungsiPerangkat = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Catatan Cek Perangkat',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
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
                                  catatanCekPerangkat = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
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
                              // Simpan data ke database atau lakukan operasi lainnya
                            },
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                        ],
                      )
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
}
