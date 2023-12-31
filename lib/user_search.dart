import 'package:example_1/view/user_list/model/user_database_provider.dart';
import 'package:example_1/view/user_list/model/user_model.dart';
import 'package:flutter/material.dart';

class CustomUserSearch extends StatefulWidget {
  final List<UserModel> userList;

  const CustomUserSearch(this.userList, {super.key});

  @override
  _CustomUserSearchState createState() => _CustomUserSearchState();
}

class _CustomUserSearchState extends State<CustomUserSearch> {
  late TextEditingController _searchController;
  late List<UserModel> filteredUsers;
  UserDatabase db = UserDatabase();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredUsers = List.from(widget.userList);
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredUsers = widget.userList
            .where((user) =>
                user.name!.toLowerCase().contains(query.toLowerCase()) ||
                user.team!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredUsers = List.from(widget.userList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: filterUsers,
          decoration: const InputDecoration(
            hintText: 'Search by name or team...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(filteredUsers[index].name ?? ""),
              subtitle: Text("Age: ${filteredUsers[index].age}\nTeam: ${filteredUsers[index].team}"),
              trailing: IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete"),
                        content: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                db.deleteUser(filteredUsers[index].id!).then((value) {
                                  if (value < 1) {
                                    showSnack('Could not user delete');
                                  } else {
                                    showSnack('User deleted');
                                  }
                                  setState(() {
                                    filteredUsers.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                });
                              },
                              child: const Text("Sil", style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel")),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
