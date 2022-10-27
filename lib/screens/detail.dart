import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/movie_result_model.dart';
import 'package:transparent_image/transparent_image.dart';

class MoviesDetails extends StatelessWidget {
  final List<Result> movieData;
  final int index;

  MoviesDetails(this.movieData, this.index);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String _titlePath = movieData[index].originalTitle;
    final String movieName = movieData[index].title;
    final String movieOverview = movieData[index].overview;
    final int movieId = movieData[index].id;
    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: AppBar(
            flexibleSpace: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  "https://image.tmdb.org/t/p/w500${movieData[index].posterPath}",
              fit: BoxFit.cover,
            ),
          ),
        ),
        preferredSize: Size.fromHeight(size.height / 3),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              movieName,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              movieOverview,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
