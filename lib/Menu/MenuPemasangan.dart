// ignore_for_file: file_names, library_private_types_in_public_api, unused_import
import 'package:flutter/material.dart';
import 'package:pola/BottomNavBar.dart';
import 'package:pola/Menu/MenuDrop.dart';
//Menu
import '../Menu/MenuHome.dart';
import '../Menu/MenuPM.dart';
import '../Menu/MenuCM.dart';
import '../Menu/Profile.dart';
//PO
import '../Pemasangan/InputSPK.dart';
import '../Pemasangan/Pemasangan.dart';
import '../Pemasangan/CekPerangkat.dart';
import '../Pemasangan/ListAgen.dart';
import '../Pemasangan/LaporanPemasangan.dart';
import '../user/User.dart';

class MenuPemasangan extends StatefulWidget {
  static const String id = "/MenuPemasangan";
  final User? userData;
  const MenuPemasangan({Key? key, required this.userData}) : super(key: key);

  @override
  _MenuPemasanganState createState() => _MenuPemasanganState();
}

class _MenuPemasanganState extends State<MenuPemasangan> {
  int _selectedIndex = 1;

  final List<String> _menuItems = [
    'Home',
    'Pemasangan',
    'Penarikan',
    'Profile',
  ];

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

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuHome(userData: widget.userData),
        ),
      );
      return false;
    }
    return true;
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
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'Pemasangan EDC',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuCard(
                      title: 'Input JO',
                      icon: Icons.edit_document,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputSPK(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 15.0),
                    MenuCard(
                      title: 'Cek Perangkat',
                      icon: Icons.fact_check_rounded,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CekPerangkat(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuCard(
                      title: 'Pasang Baru',
                      icon: Icons.note_add_rounded,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pemasangan(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 15.0),
                    MenuCard(
                      title: 'Laporan Pemasangan',
                      icon: Icons.description,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LaporanPemasangan(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuCard(
                      title: 'List Agen',
                      icon: Icons.list_alt_sharp,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListAgen(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          menuItems: _menuItems,
        ),
      ),
    );
  }

  IconData _getIconByMenuItem(String menuItem) {
    switch (menuItem) {
      case 'Home':
        return Icons.home;
      case 'Pemasangan':
        return Icons.build_rounded;
      case 'Penarikan':
        return Icons.remove_shopping_cart;
      case 'Profile':
        return Icons.person_sharp;
      default:
        return Icons.person;
    }
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        child: SizedBox(
          width: 60.0, // Ubah ukuran lebar Card sesuai kebutuhan
          height: 80.0, // Ubah ukuran tinggi Card sesuai kebutuhan
          child: InkWell(
            onTap: onTap as void Function()?,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.black),
                  const SizedBox(height: 10.0),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
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
