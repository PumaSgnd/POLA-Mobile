import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String username;
  final String email;
  final String role;

  User({
    required this.name,
    required this.username,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}