import 'package:flutter/material.dart';
import 'package:pola/Penarikan/LaporanWD.dart';
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

  @override
  void initState() {
    super.initState();
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
        builder: (context) => LaporanWD(userData: widget.userData),
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
                    'Edit JO Penarika',
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

void showEditAgenDialog(BuildContext context,
    {String? id,
    String? noSpk,
    String? namaAgen,
    String? alamatAgen,
    String? teleponAgen,
    String? tid,
    String? mid,
    String? kota,
    String? idKanwil}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditAgen(
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
