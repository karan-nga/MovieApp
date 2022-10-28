import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/login.dart';
import 'package:movie/screens/movies.dart';
import 'package:movie/screens/search_movies.dart';

class MoviesList extends StatefulWidget {
  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  int currentIndex = 0;
  List<Widget> _screens = [Movies(), MoviesSearch(), MyLogin()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xA1191826),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
