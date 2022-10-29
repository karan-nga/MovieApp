import 'package:flutter/cupertino.dart';

import '../const/constants.dart';
import 'package:movie/models/searchModel.dart';
import 'package:http/http.dart' as http;

class SearchData{
   static List<Result> moviesData=[];
   static Future<List<Result>> getMoviesList(String query) async{
     http.Response response;
     response = await http.get(Uri.parse('${ApiConstants.SearchUrl}+$query'));
     if (response.statusCode == 200) {
       final moviesResult = searchModelFromJson(response.body);
       moviesData = moviesResult.results;
       print(moviesData.toString());

     } else {
       print('Request failed with status :${response.statusCode}');
     }
     return moviesData;
   }
}