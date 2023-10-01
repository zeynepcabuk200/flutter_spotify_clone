import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigations/tabbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white10,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
                fontSize: 12
            ),
            unselectedLabelStyle: TextStyle(
                fontSize: 12
            ),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38
          )), //üst siyah altta beyaz tabbar
      home: Tabbar(),
    );
  }
}
