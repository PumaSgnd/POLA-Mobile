import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pola/user/User.dart';

class ApiService {
  final String baseUrl = 'http://10.20.20.195/fms/api/user_api/login';

  Future<Map<String, dynamic>> login(String username, String password) async {
    Map data = {'username': username, 'password': password};
    String body = json.encode(data);
    var client = http.Client();

    Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'username': username,
      'password': password,
    });

    http.Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return {
        'status': true,
        'data': User.fromJson(data),
      };
    } else if (response.statusCode == 404) {
      return {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    } else {
      throw Exception('Failed to login');
    }
  }
}
