import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie_result_model.dart';

class MoviesList extends StatefulWidget {
  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  late List<Result> moviesData;
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future getMovies() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=7d79a0348d08945377e89a95cd670c5a&language=en-US'));
    if (response.statusCode == 200) {
      final moviesResult = moviesResultFromJson(response.body);
      moviesData = moviesResult.results;
      print(response.headers.toString());
      print(moviesResult.toJson().toString());

      setState(() {
        waiting = false;
      });
    }
    else {
      print('Request failed with status :${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    getMovies();
    return Scaffold(
        backgroundColor: Color(0xff191826),
    appBar: AppBar(
    centerTitle: false,
    title: Text(
    'MOVIES',
    style: TextStyle(fontSize: 25.0, color: Color(0xfff43370)),
    ),
    elevation: 0.0,
    backgroundColor: Color(0xff191826),
    ),
    body: (waiting)
    ? Center(
    child: CircularProgressIndicator(
    color: Colors.blueAccent,
    )
    ,
    )
        : ListView.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
    itemCount: (moviesData != null) ? moviesData.length: 1,
    itemBuilder: (BuildContext context, index) {
    return Row(
    children: [
    // GestureDetector(
    //   onTap: (){
    //
    //   },
    // ),
    Container(
    height: 250,
    alignment: Alignment.centerLeft,
    child: Card(
    child: Image.network(
    "https://image.tmdb.org/t/p/w500${moviesData[index].posterPath}"),
    ),
    ),
    SizedBox(
    width: 20,
    ),
    Expanded(
    child: Container(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(
    height: 20.0,
    ),
    Text(
      moviesData[index].originalTitle,
    style: TextStyle(color: Colors.white),
    ),
    SizedBox(
    height: 10,
    ),
    Text(
      moviesData[index].releaseDate.toLocal().toString(),
    style: TextStyle(color: Color(0xff868597)),
    ),
    SizedBox(
    height: 10,
    ),
    Container(
    height: 100,
    child: Text(
    moviesData[index].overview,

    style: TextStyle(color: Color(0xff868597)),
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    );
    },
    ));
  }


}
