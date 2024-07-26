// MenuHome.dart
import 'package:flutter/material.dart';
import '../Login/Login.dart';
import '../user/User.dart';
import 'package:intl/intl.dart';

//Menu
import '../Menu/MenuPemasangan.dart';
import 'package:pola/Menu/MenuDrop.dart';
// import '../Menu/MenuCM.dart';
// import '../Menu/MenuPM.dart';
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

    int stokInventori = 0;
    int pemasangan = 0;
    int preventiveMaintenance = 0;
    int correctiveMaintenance = 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFE4EDF3),
      drawer: Drawer(
        child: Container(
          width: 200, // Ubah ukuran lebar Drawer sesuai kebutuhan
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(capitalize('Guest')),
                accountEmail: Text(capitalize('')),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuHome(userData: widget.userData,),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Pemasangan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPemasangan(userData: widget.userData),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Penarikan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WithDrawal(userData: widget.userData),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Login.id);
                },
              ),
            ],
          ),
        ),
      ),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuCard(
                    title: 'Agen',
                    value: pemasangan,
                    onTap: () {
                      // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
                    },
                  ),
                  MenuCard(
                    title: 'Stok Inventory',
                    value: stokInventori,
                    onTap: () {
                      // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuCard(
                    title: 'Preventive Maintenance',
                    value: preventiveMaintenance,
                    onTap: () {
                      // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
                    },
                  ),
                  MenuCard(
                    title: 'Corrective Maintenance',
                    value: correctiveMaintenance,
                    onTap: () {
                      // Tambahkan logika navigasi atau tindakan yang sesuai jika diperlukan
                    },
                  ),
                ],
              ),
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
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Mengatur sudut bulat
        ),
        child: SizedBox(
          width: 170,
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
