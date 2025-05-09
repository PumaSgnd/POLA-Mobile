import 'dart:convert';
import 'package:flutter/material.dart';
import '../Login/Login.dart';
import '../user/User.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//Menu
import '../Menu/MenuPemasangan.dart';
import 'package:pola/Menu/MenuDrop.dart';
import '../Menu/Profile.dart';
import 'package:pola/BottomNavBar.dart';

class MenuHome extends StatefulWidget {
  static const String id = "/Home";
  final User? userData;
  const MenuHome({Key? key, required this.userData}) : super(key: key);
  // required this.userData
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuHome> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Home',
    'Pemasangan',
    'Penarikan',
    'Profile',
  ];

  int stok = 0;
  int pemasangan = 0;
  int pm = 0;
  int cm = 0;

  @override
  void initState() {
    super.initState();
    fetchPemasangan();
    // fetchpm();
    // fetchcm();
    fetchstok();
  }

  Future<void> fetchPemasangan() async {
    final url = 'http://192.168.203.113/pola/api/home_api/pemasangan';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pemasangan = data['pemasangan'];
        });
      } else {
        print('Failed to load pemasangan data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load pemasangan data');
      }
    } catch (e) {
      print('Error fetching pemasangan data: $e');
    }
  }

  // Future<void> fetchpm() async {
  //   final url = 'http://10.20.20.195/fms/api/home_api/pm';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         pm = data['pm'];
  //       });
  //     } else {
  //       print('Failed to load pm data: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       throw Exception('Failed to load pm data');
  //     }
  //   } catch (e) {
  //     print('Error fetching pm data: $e');
  //   }
  // }

  // Future<void> fetchcm() async {
  //   final url = 'http://10.20.20.195/fms/api/home_api/cm';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         cm = data['cm'];
  //       });
  //     } else {
  //       print('Failed to load cm data: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       throw Exception('Failed to load cm data');
  //     }
  //   } catch (e) {
  //     print('Error fetching cm data: $e');
  //   }
  // }

  Future<void> fetchstok() async {
    final url = 'http://192.168.203.113/pola/api/home_api/stok';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          stok = data['stok'];
        });
      } else {
        print('Failed to load stok data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load stok data');
      }
    } catch (e) {
      print('Error fetching stok data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke menu yang dipilih
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuHome(userData: widget.userData),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPemasangan(userData: widget.userData),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WithDrawal(userData: widget.userData),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(userData: widget.userData),
          ),
        );
        break;
    }
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    final String? username = widget.userData?.name;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      ),
      backgroundColor: const Color(0xFFE4EDF3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$formattedDate',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: 'Selamat datang ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black, // Pastikan untuk menetapkan warna teks
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${username?[0].toUpperCase()}${username?.substring(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuCard(
                    title: 'Agen',
                    value: pemasangan,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuCard(
                    title: 'Stok Inventory',
                    value: stok,
                    onTap: () {},
                  ),
                ],
              ),
              // const SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     MenuCard(
              //       title: 'Preventive Maintenance',
              //       value: pm,
              //       onTap: () {
              //         // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
              //       },
              //     ),
              //     MenuCard(
              //       title: 'Corrective Maintenance',
              //       value: cm,
              //       onTap: () {
              //         // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        menuItems: _menuItems,
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final int value;
  final Function onTap;

  const MenuCard(
      {Key? key, required this.title, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Mengatur sudut bulat
        ),
        child: SizedBox(
          width: 320,
          height: 100.0,
          child: InkWell(
            onTap: onTap as void Function()?,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0), // Atur padding ke kanan
                      child: Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0), // Atur padding ke kanan
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
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
}
