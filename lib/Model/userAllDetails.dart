import 'package:task/Model/User';

class userDetailsApiResponse {
  final List<User> users;
  final total_pages;

  userDetailsApiResponse({required this.users, required this.total_pages});

  factory userDetailsApiResponse.fromJson(Map<String, dynamic> json) {
    return userDetailsApiResponse(
        users:
            (json['data'] as List).map((user) => User.fromJson(user)).toList(),
        total_pages: json['total_pages']);
  }
}
