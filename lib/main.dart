import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nike/page/cart_page.dart';
import 'package:nike/page/home_page.dart';
import 'package:nike/page/shoe_page.dart';
import 'package:nike/page/user_page.dart';
import 'package:nike/state/add.dart';
import 'package:nike/state/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0;
  final page = [
    home_page(),
    shoe_page(),
    cart_page(),
    user_page(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            child: Image(
              image: AssetImage('images/logo.png'),
            ),
          ),
          actions: [
            search1(),
          ],
        ),
        body: page[pageIndex],
        floatingActionButton: Add(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          backgroundColor: Color(0xFF1f2729),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF4ec5a5),
          unselectedItemColor: Color(0xFFc1c1c1),
          iconSize: 20,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.roller_skating),
              label: 'Shoe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
class search1 extends StatelessWidget {
  const search1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.search,
        ),
        color: Color(0xFF1e1e1e),
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return search();
          })),
        });
  }
}

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return add();
        }));
      },
      backgroundColor: Color(0xFF56be99),
      child: Icon(Icons.add),
    );
  }
}
