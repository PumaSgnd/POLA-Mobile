import 'package:flutter/material.dart';
import 'package:pola/Pemasangan/ListAgen.dart';
import 'package:pola/Penarikan/ListWD.dart';

import '../../user/User.dart';

// Define a data model for the details
class DetailModel {
  final String noSpk;
  final String tglInputSpk;
  final String jamInputSpk;
  final String tglPemasangan;
  final String jamPemasangan;
  final String namaAgen;
  final String teleponAgen;
  final String alamatAgen;
  final String kota;
  final String kanwil;
  final String serialNumber;
  final String tid;
  final String mid;
  final String fungsiPerangkat;
  final String statusPemasangan;
  final String fotoPemasangan;
  final String fotoAgen;
  final String fotoBanner;
  final String fotoTempat;
  final String fotoTransaksi1;
  final String fotoTransaksi2;
  final String fotoTransaksi3;

  DetailModel({
    required this.noSpk,
    required this.tglInputSpk,
    required this.jamInputSpk,
    required this.tglPemasangan,
    required this.jamPemasangan,
    required this.namaAgen,
    required this.teleponAgen,
    required this.alamatAgen,
    required this.kota,
    required this.kanwil,
    required this.serialNumber,
    required this.tid,
    required this.mid,
    required this.fungsiPerangkat,
    required this.statusPemasangan,
    required this.fotoPemasangan,
    required this.fotoAgen,
    required this.fotoBanner,
    required this.fotoTempat,
    required this.fotoTransaksi1,
    required this.fotoTransaksi2,
    required this.fotoTransaksi3,
  });
}

class DetailPage extends StatefulWidget {
  final String detailId;
  final User? userData;
  const DetailPage({Key? key, required this.detailId, required this.userData}) : super(key: key);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  Future<DetailModel> fetchDetailData(String detailId) async {
    // Simulate fetching data from your database
    return DetailModel(
      noSpk: "SPK123",
      tglInputSpk: "2023-07-02",
      jamInputSpk: "10:00:00",
      tglPemasangan: "2023-07-02",
      jamPemasangan: "10:00:00",
      namaAgen: "Nama Agen",
      teleponAgen: "08123456789",
      alamatAgen: "Alamat Agen",
      kota: "Kota",
      kanwil: "Kanwil",
      serialNumber: "SN123456",
      tid: "TID123",
      mid: "MID123",
      fungsiPerangkat: "Fungsi Perangkat",
      statusPemasangan: "Terpasang",
      fotoPemasangan: "https://via.placeholder.com/150",
      fotoAgen: "https://via.placeholder.com/150",
      fotoBanner: "https://via.placeholder.com/150",
      fotoTempat: "https://via.placeholder.com/150",
      fotoTransaksi1: "https://via.placeholder.com/150",
      fotoTransaksi2: "https://via.placeholder.com/150",
      fotoTransaksi3: "https://via.placeholder.com/150",
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
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
        body: FutureBuilder<DetailModel>(
          future: fetchDetailData(widget.detailId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              DetailModel detail = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const Text(
                      'Input JO Penarikan',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Overview',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 14,
                                color: Colors.black87,
                              ),
                              label: const Text(
                                'Kembali',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildJobOrderCard(detail),
                    buildAgentCard(detail),
                    buildDeviceCard(detail),
                    buildInstallationStatusCard(detail),
                    buildDocumentationCard(detail),
                    buildTransactionCard(detail),
                  ],
                ),
              );
            } else {
              return Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  Widget buildJobOrderCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRow('Nomor JO', detail.noSpk),
            buildRow('Tanggal Input JO',
                '${detail.tglInputSpk} ${detail.jamInputSpk}'),
            buildRow('Tanggal Pemasangan JO',
                '${detail.tglPemasangan} ${detail.jamPemasangan}'),
            buildRow('File Dokumen', 'Download', isLink: true),
            buildRow('File Dokumen Penarikan', 'Download', isLink: true),
          ],
        ),
      ),
    );
  }

  Widget buildAgentCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRow('Nama Agen', detail.namaAgen),
            buildRow('Telepon', detail.teleponAgen),
            buildRow('Alamat Agen', detail.alamatAgen),
            buildRow('Kota', detail.kota),
            buildRow('Kanwil', detail.kanwil),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perangkat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRow('Serial Number', detail.serialNumber),
            buildRow('TID', detail.tid),
            buildRow('MID', detail.mid),
            buildRow('Perangkat', detail.fungsiPerangkat),
          ],
        ),
      ),
    );
  }

  Widget buildInstallationStatusCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status Pemasangan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRow('Status Pemasangan', detail.statusPemasangan),
          ],
        ),
      ),
    );
  }

  Widget buildDocumentationCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dokumentasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildImageRow('Foto Pemasangan', detail.fotoPemasangan),
            buildImageRow('Foto Perangkat & Agen', detail.fotoAgen),
            buildImageRow('Foto Banner', detail.fotoBanner),
            buildImageRow('Foto Tempat', detail.fotoTempat),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionCard(DetailModel detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaksi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildImageRow('Foto Transaksi Tunai', detail.fotoTransaksi1),
            buildImageRow('Foto Transaksi Debit', detail.fotoTransaksi2),
            buildImageRow('Foto Transaksi Antar Bank', detail.fotoTransaksi3),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // Set font weight to normal
            ),
          ),
          isLink
              ? GestureDetector(
                  onTap: () {
                    // Handle link tap, e.g., open a file
                  },
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight:
                          FontWeight.normal, // Set font weight to normal
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal, // Set font weight to normal
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildImageRow(String label, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // Set font weight to normal
            ),
          ),
          const SizedBox(width: 10),
          Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
