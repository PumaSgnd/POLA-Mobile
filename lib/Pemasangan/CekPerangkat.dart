import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String serialNumber = " ";
  String tid = " ";
  String? spk = " ";
  String? kanwil = " "; 
  String? namaAgen;
  List<String> suggestions = [];
  List<Map<String, dynamic>> suggestionList = [];
  TextEditingController _namaAgenController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  String selectedNamaAgen = "";
  String? alamatAgen = " ";
  String? fungsiPerangkat;
  String _scanBarcode = '';
  String selectedTestFungsi = "";
  List<Map<String, dynamic>> testFungsiItems = [];
  Map<String, String> testFungsi = {};
  String? catatanCekPerangkat = " ";
  bool isBoxVisible = false;

  @override
  void initState() {
    super.initState();
    fetchCekPerangkat();
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

  Future<void> save() async {
    // final url =
    //     Uri.parse('http://10.20.20.195/fms/api/pemasangan_api/save_test');

    // final Map<String, dynamic> body = Map<String, dynamic>();

    // for (int i = 0; i < testFungsiItems.length; i++) {
    //   body['fungsi[$i]'] = json.encode(testFungsiItems[i]);
    // }

    // print(body);

    final url =
        Uri.parse('http://10.20.20.195/fms/api/pemasangan_api/save_test');

    final Map<String, dynamic> body = {};

    for (int i = 0; i < testFungsiItems.length; i++) {
      final item = testFungsiItems[i];
      final itemId = item['id'].toString();

      body['fungsi[$i]'] = {
        'id': item['id'],
        'item': item['item'],
        'status': testFungsi[itemId] ?? '',
      };
    }

    final response = await http.post(
      url,
      body: json.encode({
        'id_spk': spk,
        'fungsi_perangkat': fungsiPerangkat,
        'catatan_test': catatanCekPerangkat,
        'serial_number': _serialNumberController.text,
        'id_item_test': body,
        'kawil': kanwil,
      }),
    );

    print(response.body);

    // if (this.products != null) {

    // }

    // final idItemTestString = testFungsiItems.map((item) {
    //   return 'id_item_test[${item['id']}]=${Uri.encodeComponent(testFungsi[item['id'].toString()] ?? '')}';
    // }).join('&');

    // print(idItemTestString);

    // if (response.statusCode == 200) {
    //   final responseData = jsonDecode(response.body);
    //   if (responseData['success']) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(responseData['msg'])),
    //     );
    //     // Clear fields or navigate as needed
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(responseData['err_msg'])),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to save data')),
    //   );
    // }
  }

  Future<void> fetchAgenSuggestions(String keyword) async {
    final Uri uri = Uri.parse(
      'http://10.20.20.195/fms/api/pemasangan_api/find_by_agen?nama_agen=$keyword',
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
                spk = suggestionMap['spk'] ?? '';
                kanwil = suggestionMap['kanwil'] ?? '';

                print(spk);
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

  Future<void> fetchCekPerangkat() async {
    final String baseUrl =
        "http://10.20.20.195/fms/api/pemasangan_api/cek_perangkat";

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> listItemTest = responseData['data'];

          if (listItemTest.isNotEmpty) {
            setState(() {
              testFungsiItems = listItemTest
                  .map((item) => {
                        'id': item['id'],
                        'item': item['item'],
                        // 'status': item['']
                      })
                  .toList();

              if (testFungsiItems.isNotEmpty) {
                selectedTestFungsi = testFungsiItems[0]['id'].toString();
              }
            });
          }
        } else {
          print("Error fetching Cek Perangkat data");
        }
        print('Cek Perangkat data: $testFungsiItems');
      } else {
        print("Error fetching Cek Perangkat data: ${response.statusCode}");
      }
    } catch (error) {
      print('An error occurred while fetching Cek Perangkat data: $error');
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
                        ),
                      ),
                      Visibility(
                        visible: isBoxVisible,
                        child: Container(
                          height: 100, // Adjust height as needed
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
                                      _namaAgenController.text =
                                          selectedSuggestion;
                                      alamatAgen =
                                          suggestionMap['alamat'] ?? '';
                                      tid = suggestionMap['tid'] ?? '';
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
                          maxLines: null,
                          minLines: 1,
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
                        height: 103.0,
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
                            // const SizedBox(height: 5.0),
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
                              'Test Fungsi',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height:
                                  8.0, // Menambahkan jarak antara judul dan pilihan radio
                            ),
                            Column(
                              children: testFungsiItems.map((item) {
                                String itemId = item['id'].toString();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' ${item['item']} *',
                                      style: const TextStyle(fontSize: 13.0),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                            title: const Text('OK'),
                                            value: 'OK',
                                            groupValue: testFungsi[itemId],
                                            onChanged: (value) {
                                              setState(() {
                                                testFungsi[itemId] =
                                                    value.toString();
                                                print(
                                                    'Saved Value for $itemId: $value');
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                            title: const Text('NOK'),
                                            value: 'NOK',
                                            groupValue: testFungsi[itemId],
                                            onChanged: (value) {
                                              setState(() {
                                                testFungsi[itemId] =
                                                    value.toString();
                                                print(
                                                    'Saved Value for $itemId: $value');
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
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
                              save();
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
