import 'package:example_1/users.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white54, fontSize: TextSizes.titleSize),
          centerTitle: true,
          color: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
          ),
        ),
        scaffoldBackgroundColor: Colors.tealAccent,
        useMaterial3: true,
      ),
      home: const UserView(title: 'My Contacts'),
    );
  }
}

class TextSizes {
  static const double titleSize = 24.0;
}
