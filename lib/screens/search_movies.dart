import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/const/constants.dart';
import 'package:movie/models/searchModel.dart';
import 'package:movie/reuse/reuseWidget.dart';

class MoviesSearch extends StatefulWidget {
  @override
  State<MoviesSearch> createState() => _MoviesSearchState();
}

class _MoviesSearchState extends State<MoviesSearch> {
  TextEditingController movieName = new TextEditingController();
  late List<Result> moviesData;
  bool waiting = true;
  String body = "";

  @override
  void initState() {
    super.initState();
    searchMovie("adam");
  }

  Future searchMovie(String name) async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiConstants.SearchUrl}+$name'));
    if (response.statusCode == 200) {
      final moviesResult = searchModelFromJson(response.body);
      moviesData = moviesResult.results;
      snackbar(context, "searchMovie called");
      print(moviesData.toString());
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
          elevation: 0.0,
          backgroundColor: Color(0xff191826),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Serch for a movie",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: movieName,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff302360),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  hintText: "God Father",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.white,
                ),
                onChanged: (String value) {
                  setState(() {
                    body = value;
                    searchMovie(body.trim());
                  });
                },
              ),
              SizedBox(height: 20.0),
              Expanded(
                  child: ListView.builder(
                      itemCount: moviesData.length,
                      itemBuilder: (context, index) => ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text(
                              moviesData[index].title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              moviesData[index].releaseDate.substring(0, 4),
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              moviesData[index].voteAverage.toString(),
                              style: TextStyle(color: Colors.amber),
                            ),
                            leading:  FadeInImage(
                              image: NetworkImage("https://image.tmdb.org/t/p/w500/${moviesData[index].posterPath}"),
                              placeholder: AssetImage(
                                  "assests/warning.png"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assests/warning.png'
                                );
                              },

                            ),
                          )))
            ],
          ),
        ));
  }
}
// Widget getBody() {
// Padding(
//   padding: EdgeInsets.all(16),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "Serch for a movie",
//         style: TextStyle(
//             color: Colors.white,
//             fontSize: 22.0,
//             fontWeight: FontWeight.bold),
//       ),
//       SizedBox(
//         height: 20.0,
//       ),
//       TextField(
//         controller: movieName,
//         style: TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Color(0xff302360),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none),
//           hintText: "God Father",
//           prefixIcon: Icon(Icons.search),
//           prefixIconColor: Colors.white,
//         ),
//         onSubmitted: (String value) {
//           setState(() {
//             body=value;
//             searchMovie(value.trim());
//           });
//         },
//       )
//     ],
//   ),
// );
//     return Expanded(
//         child: ListView.builder(
//             itemCount: moviesData.length,
//             itemBuilder: (context, index) => ListTile(
//                   contentPadding: EdgeInsets.all(8.0),
//                   title: Text(
//                     moviesData[index].title,
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     moviesData[index].releaseDate.substring(0, 4),
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   trailing: Text(
//                     moviesData[index].voteAverage.toString(),
//                     style: TextStyle(color: Colors.amber),
//                   ),
//               leading: Image.network("https://image.tmdb.org/t/p/w500${moviesData[index].posterPath}"),
//                 )));
//   }
// }

