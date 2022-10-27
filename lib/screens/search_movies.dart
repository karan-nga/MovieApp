import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoviesSearch extends StatefulWidget {
  const MoviesSearch({Key? key}) : super(key: key);

  @override
  State<MoviesSearch> createState() => _MoviesSearchState();
}

class _MoviesSearchState extends State<MoviesSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Search Movies',
          style: TextStyle(fontSize: 25.0, color: Color(0xfff43370)),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff191826),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Serch for a movie",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              style: TextStyle(color:Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff302360),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                hintText: "God Father",
                  prefixIcon:Icon(Icons.search),
                prefixIconColor: Colors.white

              ),
            )
          ],
        ),
      ),
    );
  }
}
