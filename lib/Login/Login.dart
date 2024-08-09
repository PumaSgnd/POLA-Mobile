// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Apiservice.dart';
import '../Menu/MenuHome.dart';
import '../user/User.dart';

class Login extends StatefulWidget {
  static String id = "/login";
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

// $2y$10$1F.Fk4s3/k6D3/Cj5xifSO4qcOn4MTHr6n0zjgWfWN6ipU/kqaf9y

class _LoginState extends State<Login> {
  bool check = false;
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    try {
      final result = await _apiService.login(username, password);

      if (result['status']) {
        final User user = result['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuHome(userData: user),
          ),
        );
      } else {
        _showDialog('Login Failed',
            result['message'] ?? 'Invalid username or password.');
      }
    } catch (e) {
      _showDialog('Login Failed', 'An error occurred while logging in.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFE4EDF3),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.width * 0.1),
            child: Column(
              children: [
                const SizedBox(
                  height: 130,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 350,
                    height: 150,
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.all(8.0), // Padding around the TextField
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Border color
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  child: TextField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      isDense: true, // Make the input field smaller
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              10.0), // Adjust padding to make the field smaller
                      hintText: "Username",
                      hintStyle: TextStyle(
                        height:
                            4, // Adjust this value to align the text properly
                      ),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none, // Remove default border
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.016),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.all(8.0), // Padding around the TextField
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Border color
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true, // Make the input field smaller
                      contentPadding: const EdgeInsets.symmetric(
                          vertical:
                              10.0), // Adjust padding to make the field smaller
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        height:
                            4, // Adjust this value to align the text properly
                      ),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.029),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: const Color(0xFF1F2855),
                  ),
                  onPressed: _login,
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
