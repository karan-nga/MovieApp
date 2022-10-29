import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/movie_result_model.dart';
import 'detail.dart';

class Movies extends StatefulWidget {
  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
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
    } else {
      print('Request failed with status :${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Movies',
          style: TextStyle(fontSize: 25.0, color: Color(0xfff43370)),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff191826),
      ),
      body: (waiting)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: (moviesData != null) ? moviesData.length : 1,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MoviesDetails(moviesData, index)));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 250,
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Card(
                          child: FadeInImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/${moviesData[index].posterPath}"),
                            placeholder: AssetImage("assests/load.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assests/warning.png');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
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
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                moviesData[index]
                                    .releaseDate
                                    .toString()
                                    .substring(0, 4),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            Text(
                                  moviesData[index].overview,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'IMDB ${moviesData[index].voteAverage.toString()}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
