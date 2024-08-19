// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import '../BottomNavBar.dart';
import '../Login/Login.dart';
import '../user/User.dart';
import '../Profile/Ubahpass.dart';
//Menu
import '../Menu/MenuHome.dart';
import '../Menu/MenuPemasangan.dart';
import '../Menu/MenuDrop.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPM.dart';

class Profile extends StatefulWidget {
  static const String id = "/Profile";
  final User? userData;
  const Profile({Key? key, required this.userData}) : super(key: key);
  @override
  _ProfileMenu createState() => _ProfileMenu();
}

class _ProfileMenu extends State<Profile> {
  int _selectedIndex = 3;

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

  late String username = 'Agus Darma';
  final String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final String? username = widget.userData?.name;

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
        body: Column(
          children: [
            const SizedBox(height: 20.0),
            const Row(
              children: [
                SizedBox(width: 20.0),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 125.0),
            Center(
              child: Card(
                color: Colors.white,
                elevation: 10.0,
                margin: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        '${username?[0].toUpperCase()}${username?.substring(1)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Ubah Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePassword(
                              userData: widget.userData,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Versi Aplikasi'),
                      subtitle: Text(appVersion),
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Keluar'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Keluar'),
                              content: const Text(
                                  'Anda yakin ingin keluar dari akun?'),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Keluar',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const Login(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
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
      case 'Job Orders':
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
