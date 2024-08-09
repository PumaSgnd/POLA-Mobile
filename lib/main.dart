// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pola/Splash.dart';
//Login
import '../Login/Login.dart';
//Menu
import '../Menu/MenuHome.dart';
import '../Menu/MenuPemasangan.dart';
import '../Menu/MenuCM.dart';
import '../Menu/MenuPM.dart';
import '../Menu/Profile.dart';
//Pemasangan
import '../Pemasangan/InputSPK.dart';
import '../Pemasangan/CekPerangkat.dart';
import '../Pemasangan/LaporanPemasangan.dart';
import '../Pemasangan/ListAgen.dart';
import '../Pemasangan/Pemasangan.dart';
//Penarikan
import 'package:pola/Menu/MenuDrop.dart';
// //CM
// import '../CM/DataLaporanGangguan.dart';
// import '../CM/EditPage.dart';
// import '../CM/LaporanCM.dart';
// import '../CM/LaporanGangguan.dart';
// //PM
// import '../PM/JadwalPM.dart';
// import '../PM/LaporanPM.dart';
// import '../PM/HistoryPM.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'POLA APP',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Color(0xFF1F2855),
            ),
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(Colors.transparent),
            ),
            bottomAppBarTheme: const BottomAppBarTheme(
              color: Color(0xFF1F2855),
            )),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          Login.id: (context) => const Login(),
          //Menu
          MenuHome.id: (context) => const MenuHome(userData: null),
          MenuPemasangan.id: (context) => const MenuPemasangan(userData: null),
          WithDrawal.id: (context) => const WithDrawal(userData: null),
          Profile.id: (context) => const Profile(
                userData: null,
              ),
          //JO
          InputSPK.id: (context) => const InputSPK(userData: null),
          CekPerangkat.id: (context) => const CekPerangkat(userData: null),
          LaporanPemasangan.id: (context) =>
              const LaporanPemasangan(userData: null),
          ListAgen.id: (context) => const ListAgen(userData: null),
          Pemasangan.id: (context) => const Pemasangan(userData: null),
          //WD
          // InputWDEDC.id: ,
        } // Set the Login as the initial route
        );
  }
}
