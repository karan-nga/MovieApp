import 'package:flutter/cupertino.dart';
import 'package:movie/models/trending_model.dart';

import '../const/constants.dart';
import 'package:movie/models/searchModel.dart';
import 'package:http/http.dart' as http;

class TrendingMoviesResult{
    List<TrendingResult> moviesData=[];
    Future<List<TrendingResult>> getTrending() async{
     http.Response response;
     response = await http.get(Uri.parse('https://api.themoviedb.org/3/trending/movie/day?api_key=7d79a0348d08945377e89a95cd670c5a'));
     if (response.statusCode == 200) {
       final moviesResult = tredingModelFromJson(response.body);
       moviesData = moviesResult.results!;
       print(moviesData.toString());

     } else {
       print('Request failed with status :${response.statusCode}');
     }
     return moviesData;
   }
}