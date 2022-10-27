import 'dart:convert';
import 'package:http/http.dart' as http;
class MoviesResult{
  fetchMovies() async {
    var url;
    url = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=7d79a0348d08945377e89a95cd670c5a&language=en-US"));
    return json.decode(url.body)['results'];
  }
}