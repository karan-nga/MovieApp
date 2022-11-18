import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/screens/nav_bar.dart';
import 'package:movie/screens/search/movies_find.dart';
import 'package:movie/screens/trending_movies_list.dart';

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
    print("call1");
    getMovies();
  }

  Future getMovies() async {
    print("call api");
    http.Response response;
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=7d79a0348d08945377e89a95cd670c5a&language=en-US'));
    if (response.statusCode == 200) {
      final moviesResult = moviesResultFromJson(response.body);
      moviesData = moviesResult.results;
      // print(response.headers.toString());
      // print(moviesResult.toJson().toString());

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
      drawer: NavBar(),
      backgroundColor: Color(0xff191826),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'MOVIES',
          style: TextStyle(fontSize: 25.0, color: Color(0xfff43370)),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff191826),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              final result =
              showSearch(context: context, delegate: MoviesDelegate());
            },
          )
        ],
      ),
      body: (waiting)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : Container(

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (moviesData != null) ? moviesData.length : 0,
                    itemBuilder: (BuildContext context, index) {
                      print("list view call");
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MoviesDetails(moviesData[index].posterPath.toString(),
                                      moviesData[index].title.toString(),moviesData[index].overview,
                                      moviesData[index].voteAverage.toString(),
                                      moviesData[index].releaseDate.toString())));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[

                            Container(
                              height: 250,
                              width: 170,
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: Card(color: Colors.transparent,

                                child: FadeInImage(placeholderFit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w500/${moviesData[index].posterPath}",),

                                  placeholder: AssetImage("assests/load.png"),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assests/warning.png');
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      moviesData[index].title,
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
                                      TextStyle(color: Colors.amber, fontSize: 16),
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
                  TrendingMoviesList(),
                ],
              ),
            ),

      ),

          );

  }
}
