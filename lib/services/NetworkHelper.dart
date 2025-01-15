import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task/Model/User';

class NetworkHelper {
  final String apiUrl;

  NetworkHelper(this.apiUrl);

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) {
          return User.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
