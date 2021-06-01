import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import 'package:http/http.dart' as http;
import './profile.dart';
import './users_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, Object>> _pages;

  initState() {
    _pages = [
      {
        'page': UsersList(),
        'title': "Users List",
      },
      {
        'page': Profile(),
        'title': 'Profile',
      },
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      await Provider.of<Auth>(context, listen: false).logout();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _pages[_selectedPageIndex]["title"].toString(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              splashColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
        body: _pages[_selectedPageIndex]["page"] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_off_rounded),
              label: "Users",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: "Profile",
            ),
          ],
          onTap: _selectedPage,
          backgroundColor: Colors.black,
          iconSize: 35,
          showUnselectedLabels: false,
        ));
  }
}
