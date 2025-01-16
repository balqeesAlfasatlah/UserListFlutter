import 'package:flutter/material.dart';
import 'package:task/Model/User';
import 'services/NetworkHelper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task/Model/userAllDetails.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Photo List',
            style: TextStyle(
              color: Color(0xFFD1D1D1),
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF2C4F80),
        ),
        body: PhotoList(),
      ),
    );
  }
}

class PhotoList extends StatefulWidget {
  const PhotoList({super.key});

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  List<User> users = [];
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsersData();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchUsersData(); // Fetch the next page
    }
  }

  void fetchUsersData() async {
    try {
      NetworkHelper networkHelper =
          NetworkHelper('https://reqres.in/api/users');
      final fetchedUsers = await networkHelper.fetchUsers(currentPage);
      setState(() {
        users.addAll(fetchedUsers.users);
        totalPages = fetchedUsers.total_pages;
        isLoading = false; // Data loaded, stop showing the loader
        currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString(); // Show error message if any
      });
    }
  }

  // Function to show shimmer effect while data is loading
  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(radius: 30),
            title: Container(width: 100, height: 10, color: Colors.white),
            subtitle: Container(width: 150, height: 10, color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9E8B7B),
      body: isLoading && users.isEmpty
          ? buildShimmer()
          : errorMessage != null
              ? Center(
                  child: Text('Error: $errorMessage'),
                )
              : users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: users.length + 1,
                      itemBuilder: (context, index) {
                        if (index < users.length) {
                          final user = users[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Card(
                              color: Color(0xFF2C4F80),
                              elevation: 20,
                              child: Container(
                                height: 120,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image(
                                            image: NetworkImage(user.avatar),
                                            height: 100,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: TextStyle(
                                              color: Color(0xFFD1D1D1),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          if (totalPages >= (currentPage)) {
                            print("Building CircularProgressIndicator");
                            // Pagination indicator
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              //color: Colors.red,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }
                      },
                    ),
    );
  }
}
