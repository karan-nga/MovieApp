import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trending_model.dart';
import 'detail.dart';

class TrendingMoviesList extends StatefulWidget {

  @override
  State<TrendingMoviesList> createState() => _TrendingMoviesListState();
}

class _TrendingMoviesListState extends State<TrendingMoviesList> {
  List<TrendingResult> list=[];
  bool waiting = true;
  @override
  void initState() {
    super.initState();
    getTranding();
  }

  Future getTranding() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=7d79a0348d08945377e89a95cd670c5a'));
    if (response.statusCode == 200) {
      final moviesResult = tredingModelFromJson(response.body);
      list = moviesResult.results!;
      print(list[0].title);
      setState(() {
        waiting = false;
      });
    } else {
      print('Request failed with status :${response.statusCode}');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Treding List"
            , style: TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (list != null) ? list.length : 0,
                  itemBuilder: (context, index){
                     if(waiting==true||list.isEmpty==true){
                       return Center(
                           child: CircularProgressIndicator(color: Colors.blueAccent,)
                       );
                     }
                     else {
                       return InkWell(
                         // onTap: () {
                         //   Navigator.push(
                         //       context,
                         //       MaterialPageRoute(
                         //           builder: (context) =>
                         //               MoviesDetails(list, index)));
                         // },
                         child: Container(
                           width: 140,

                           child: Column(
                             children: [
                               Container(
                                 decoration: BoxDecoration(
                                     image: DecorationImage(
                                       image: NetworkImage(
                                           'https://image.tmdb.org/t/p/w500${list[index]
                                               .posterPath}'),
                                     ), borderRadius: BorderRadius.circular(20)
                                 ),
                                 height: 200,
                               ),
                               SizedBox(height: 5),
                               Container(

                                   child: Text(list[index].title.toString(),
                                     style: TextStyle(color: Colors.grey),
                                     textAlign: TextAlign.start,)
                               )
                             ],
                           ),
                         ),
                       );
                     }
                  }))
        ],
      ),
    );
  }
}