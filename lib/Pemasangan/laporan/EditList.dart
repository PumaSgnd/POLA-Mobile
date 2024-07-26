import 'package:flutter/material.dart';
import 'package:pola/Pemasangan/ListAgen.dart';
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
  late TextEditingController _statusController;
  late TextEditingController _catatanController;
  String? _selectedKota;
  String? _selectedKanwil;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _noSpkController = TextEditingController(text: widget.noSpk);
    _namaAgenController = TextEditingController(text: widget.namaAgen);
    _alamatAgenController = TextEditingController(text: widget.alamatAgen);
    _teleponAgenController = TextEditingController(text: widget.teleponAgen);
    _serialNumberController = TextEditingController(text: widget.serialNumber);
    _tidController = TextEditingController(text: widget.tid);
    _midController = TextEditingController(text: widget.mid);
    _statusController = TextEditingController(text: widget.status);
    _catatanController = TextEditingController(text: widget.catatan);
    _selectedKota = widget.kota;
    _selectedKanwil = widget.idKanwil;
  }

  @override
  void dispose() {
    _noSpkController.dispose();
    _namaAgenController.dispose();
    _alamatAgenController.dispose();
    _teleponAgenController.dispose();
    _serialNumberController.dispose();
    _tidController.dispose();
    _midController.dispose();
    _statusController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // Handle save logic here
      Navigator.of(context).pop();
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
                            Text('NOMOR JO'),
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
                            Text('AGEN'),
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
                            Text('ALAMAT AGEN'),
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
                            Text('TELEPON AGEN'),
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
                            Text('SERIAL NUMBER'),
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
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('KOTA'),
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
                        DropdownButtonFormField<String>(
                          value: _selectedKota,
                          onChanged: (value) {
                            setState(() {
                              _selectedKota = value;
                            });
                          },
                          items: <String>[
                            'Kota 1',
                            'Kota 2',
                            'Kota 3',
                          ].map((String kota) {
                            return DropdownMenuItem<String>(
                              value: kota,
                              child: Text(kota),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kota is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('KANWIL'),
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
                        DropdownButtonFormField<String>(
                          value: _selectedKanwil,
                          onChanged: (value) {
                            setState(() {
                              _selectedKanwil = value;
                            });
                          },
                          items: <String>[
                            'Kanwil 1',
                            'Kanwil 2',
                            'Kanwil 3',
                          ].map((String kanwil) {
                            return DropdownMenuItem<String>(
                              value: kanwil,
                              child: Text(kanwil),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kanwil is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('CATATAN'),
                          ],
                        ),
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
                                Navigator.of(context).pop();
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
                              onPressed: _save,
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
