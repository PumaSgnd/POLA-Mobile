import 'package:flutter/material.dart';
import 'package:pola/Penarikan/LaporanWD.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../user/User.dart';

// Define a data model for the details
class Pemasangan {
  final String? id;
  final String noSpk;
  final String noSPKPenarikan;
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
  final String fotoPenarikan;

  Pemasangan({
    this.id,
    required this.noSpk,
    required this.noSPKPenarikan,
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
    required this.fotoPenarikan,
  });

  factory Pemasangan.fromJson(Map<String, dynamic> json) {
    return Pemasangan(
      id: json['id'],
      noSpk: json['no_spk'] ?? '',
      tglInputSpk: json['tgl_penarikan'] != null
          ? json['tgl_penarikan'].split(' ')[0]
          : '',
      jamInputSpk: json['tgl_penarikan'] != null
          ? json['tgl_penarikan'].split(' ')[1]
          : '',
      noSPKPenarikan: json['no_spk_penarikan'],
      tglPemasangan: json['tgl_pemasangan'] != null
          ? json['tgl_pemasangan'].split(' ')[0]
          : '',
      jamPemasangan: json['tgl_pemasangan'] != null
          ? json['tgl_pemasangan'].split(' ')[1]
          : '',
      namaAgen: json['nama_agen'] ?? '',
      teleponAgen: json['telepon'] ?? '',
      alamatAgen: json['alamat_agen'] ?? '',
      kota: json['kota'] ?? '',
      kanwil: json['kanwil'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      tid: json['tid'] ?? '',
      mid: json['mid'] ?? '',
      fungsiPerangkat: json['fungsi_perangkat'] ?? '',
      statusPemasangan: json['status_pemasangan'] ?? '',
      fotoPemasangan: json['foto_pemasangan'] ?? '',
      fotoAgen: json['foto_agen'] ?? '',
      fotoBanner: json['foto_banner'] ?? '',
      fotoTempat: json['foto_tempat'] ?? '',
      fotoTransaksi1: json['foto_transaksi1'] ?? '',
      fotoTransaksi2: json['foto_transaksi2'] ?? '',
      fotoTransaksi3: json['foto_transaksi3'] ?? '',
      fotoPenarikan: json['img_penarikan'] ?? '',
    );
  }
}

class DetailPage extends StatefulWidget {
  final String? id;
  final User? userData;
  const DetailPage({Key? key, required this.id, required this.userData})
      : super(key: key);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  Future<Pemasangan> fetchPenarikan(String id) async {
    final String apiUrl =
        'http://192.168.50.69/pola/api/penarikan_api/laporan_detail/$id';

    print(id);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          final data = responseData['data']['spk'];
          final pemasangan = Pemasangan.fromJson(data);

          // You can use the 'pemasangan' object as needed
          print(pemasangan.noSpk);

          // Return the Pemasangan model with the fetched data
          return pemasangan;
        } else {
          throw Exception('Failed to load details: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load details: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to load details: $error');
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
        backgroundColor: const Color(0xFFE4EDF3),
        body: FutureBuilder<Pemasangan>(
          future: fetchPenarikan(widget.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              Pemasangan detail = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const Text(
                      'Detail Laporan Penarikan',
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

  Widget buildJobOrderCard(Pemasangan detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRow('Nomor JO', detail.noSpk),
            buildRow('Tanggal Pemasangan JO',
                '${detail.tglPemasangan} ${detail.jamPemasangan}'),
            buildRow('Nomor JO Penarikan', detail.noSPKPenarikan),
            buildRow('Tanggal Pemasangan JO',
                '${detail.tglInputSpk} ${detail.jamInputSpk}'),
            buildRow('File Dokumen', 'Download', isLink: true),
            buildRow('File Dokumen Penarikan', 'Download', isLink: true),
          ],
        ),
      ),
    );
  }

  Widget buildAgentCard(Pemasangan detail) {
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

  Widget buildDeviceCard(Pemasangan detail) {
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

  Widget buildInstallationStatusCard(Pemasangan detail) {
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

  Widget buildDocumentationCard(Pemasangan detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dokumentasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Spasi antara judul dan gambar
            Wrap(
              spacing: 8.0,
              runSpacing: 15.0,
              children: [
                buildImageColumn('Foto Pemasangan',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoPemasangan}'),
                buildImageColumn('Foto Perangkat & Agen',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoAgen}'),
              ],
            ),
            Wrap(
              spacing: 8.0, // Spasi horizontal antar gambar
              runSpacing: 15.0, // Spasi vertikal antar baris gambar
              children: [
                buildImageColumn('Foto Banner',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoBanner}'),
                buildImageColumn('Foto Tempat',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoTempat}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionCard(Pemasangan detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaksi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0, // Spasi horizontal antar gambar
              runSpacing: 15.0, // Spasi vertikal antar baris gambar
              children: [
                buildImageColumn('Foto Transaksi Tunai',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoTransaksi1}'),
                buildImageColumn('Foto Transaksi Debit',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoTransaksi2}'),
              ],
            ),
            Wrap(
              spacing: 8.0, // Spasi horizontal antar gambar
              runSpacing: 15.0, // Spasi vertikal antar baris gambar
              children: [
                buildImageColumn('Foto Transaksi Antar Bank',
                    'https://pola.inti.co.id/doc/pemasangan/${detail.fotoTransaksi3}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Agar teks tidak menempel pada label
        children: [
          Expanded(
            flex: 2, // Label mengambil ruang yang diperlukan
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2, // Value akan mengisi sisa ruang yang tersedia
            child: isLink
                ? GestureDetector(
                    onTap: () {
                      // Handle link tap, e.g., open a file
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 2, // Maksimum baris yang ditampilkan
                      overflow: TextOverflow
                          .ellipsis, // Teks yang melebihi batas akan menggunakan ellipsis
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2, // Maksimum baris yang ditampilkan
                    overflow: TextOverflow
                        .ellipsis, // Teks yang melebihi batas akan menggunakan ellipsis
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String title, String imageUrl, String scale) {
    // Convert the scale from String to double
    double scaleValue = double.tryParse(scale) ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 4), // Space between text and image
        Image.network(
          imageUrl,
          width: 150, // Set the width of the image (adjust as needed)
          height: 150, // Set the height of the image (adjust as needed)
          fit: BoxFit.cover,
          scale: scaleValue, // Apply the scale value
        ),
      ],
    );
  }

  Widget buildImageColumn(String title, String imageUrl) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Teks akan diratakan ke kiri
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 4), // Spasi antara teks dan gambar
        Image.network(
          imageUrl,
          width: 150, // Tentukan lebar gambar (sesuaikan dengan kebutuhan)
          height: 150, // Tentukan tinggi gambar (sesuaikan dengan kebutuhan)
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
