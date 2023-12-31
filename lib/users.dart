import 'package:example_1/user_search.dart';
import 'package:example_1/view/user_list/model/user_database_provider.dart';
import 'package:example_1/view/user_list/model/user_model.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  const UserView({super.key, required this.title});
  final String title;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with TickerProviderStateMixin {
  bool isFilter = false;
  final String _noUser = "No Users";
  static final formState = GlobalKey<FormState>();
  final FocusNode t1 = FocusNode();
  final FocusNode t2 = FocusNode();
  final FocusNode t3 = FocusNode();
  bool _isLoading = false;
  late final UserDatabase db;
  List<UserModel> users = [];
  String searchText = '';

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    baglan();
  }

  Future<void> baglan() async {
    changeLoading();
    db = UserDatabase();
    await getUsers();
    changeLoading();
  }

  Future<void> getUsers([String s = ""]) async {
    changeLoading();
    users = await db.getUser(s);
    setState(() {});
    changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () => _addUserForm(context), icon: const Icon(Icons.add)),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomUserSearch(users),
                    ),
                  );
                },
                icon: const Icon(Icons.search_outlined),
              )
            ],
          ),
          Expanded(
            child: users.isNotEmpty
                ? ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(users[index].name ?? ""),
                          subtitle: Text("Age: ${users[index].age}\nTeam: ${users[index].team}"),
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
                                            db.deleteUser(users[index].id!).then((value) {
                                              if (value < 1) {
                                                showSnack('Could not user delete');
                                              } else {
                                                showSnack('User deleted');
                                              }
                                              setState(() {
                                                users.removeAt(index);
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
                  )
                : SizedBox(
                    height: 500,
                    child: Center(child: Text(_noUser)),
                  ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _addUserForm(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add User"),
          content: FormField(
            builder: (field) {
              String name = "";
              String age = "";
              String team = "";
              return Form(
                key: formState,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Name'),
                      TextFormField(
                        focusNode: t1,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name is not empty";
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(t2);
                        },
                        onSaved: (newValue) => name = newValue!,
                      ),
                      const Divider(),
                      const Text('Age'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: t2,
                        textInputAction: TextInputAction.newline,
                        validator: (value) {
                          if (value!.isEmpty || int.tryParse(value)! < 0) {
                            return "Age cannot be empty or less than 0";
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(t3);
                        },
                        onSaved: (newValue) => age = newValue!,
                      ),
                      const Divider(),
                      const Text('Team'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: t3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Teamless is written if input team";
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(t3);
                        },
                        onSaved: (newValue) => team = newValue!.isEmpty ? "Teamless" : newValue,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        ElevatedButton(
                          child: const Text("Ekle"),
                          onPressed: () {
                            if (formState.currentState!.validate()) {
                              formState.currentState!.save();
                              db.addUsers(UserModel(name: name, age: age, team: team)).then((value) => {
                                    if (value == -1)
                                      {showSnack("Could not add user")}
                                    else
                                      {showSnack("User added $value")}
                                  });
                              formState.currentState!.reset();
                              FocusScope.of(context).requestFocus(FocusNode());
                              getUsers();
                              setState(() {});
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Kapat'),
                        ),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
