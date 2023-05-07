import 'package:burdayim/giris.dart';
import 'package:burdayim/kayit.dart';
import 'package:flutter/material.dart';
import 'anasayfa.dart';
import 'second_page.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(home:Giris()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    AnaSayfa(),
    SecondPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Ana Sayfa ',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}