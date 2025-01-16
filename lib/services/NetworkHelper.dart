import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task/Model/User';
import 'package:task/Model/userAllDetails.dart';

class NetworkHelper {
  final String apiUrl;

  NetworkHelper(this.apiUrl);

  Future<userDetailsApiResponse> fetchUsers(int page) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?page=$page'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(ApiResponse.fromJson(jsonResponse));
        return userDetailsApiResponse.fromJson(jsonResponse);

        //final List<dynamic> data = jsonResponse['data'];
        //final Int  totalPages = jsonResponse['total_pages'];
        // data.u = data.map((json) {
        //  return User.fromJson(json);
        // }).toList() ;
        // return
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
