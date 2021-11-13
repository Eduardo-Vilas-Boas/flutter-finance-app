import 'package:flutter/material.dart';
import 'package:flutter_finance_app/services/database.dart';
import 'package:flutter_finance_app/widgets/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  startDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: ThemeData.light().textTheme.bodyText1!.copyWith(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
