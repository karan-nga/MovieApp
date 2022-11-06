import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/models/searchModel.dart';

import '../../const/constants.dart';
import '../detail.dart';

class MoviesFind extends StatefulWidget {
  @override
  State<MoviesFind> createState() => _MoviesFindState();
}

class _MoviesFindState extends State<MoviesFind> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826),
      appBar: AppBar(
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
    );
  }
}

class MoviesDelegate extends SearchDelegate<String> {
  List<Result> moviesData = [];

  Future<List<Result>> searchMovie() async {
    http.Response response;
     if(query.isEmpty==false) {
       String api='${ApiConstants.SearchUrl}+${query.trim()}';
       response = await http.get(Uri.parse(api));
       print("searchMovie called with name=" + query);
       if (response.statusCode == 200) {
         final moviesResult = searchModelFromJson(response.body);
         moviesData = moviesResult.results;
         print("data from search" + moviesData.toString());
       } else {
         print('Request failed with status :${response.statusCode}');
         print(response.statusCode);
       }
     }
       return moviesData;

}
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, query);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, query),
      );

  @override
  Widget buildResults(BuildContext context) =>buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) => Container(
    color:Color(0xff191826),
    child: FutureBuilder<List<Result>>(
          future: searchMovie(),
          builder: (context, snapshot) {
            print("box contain" + query.toString());
            if (query.isEmpty) return noSearch();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError||snapshot.data!.isEmpty) {
                  print("movies list data" + moviesData.toString());
                  print(snapshot.error);
                  print(snapshot.data.toString());
                  return noResult();
                }
                  else {
                  return buildSuggestionsSuccess(snapshot.data!);
                }
            }
          },
        ),
  );
  Widget noSearch() {
    return Center(
      child: Text("Search your movies",
          style: TextStyle(fontSize: 28, color: Colors.amber)),
    );
  }
  Widget noResult() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assests/not_found.png'),
                fit: BoxFit.fill
            )
        ),
      ),
    );
  }
  Widget buildSuggestionsSuccess(List<Result> suggestions) {
    return ListView.builder(
        itemCount: suggestions.isEmpty != true ? suggestions.length : 0,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          String relaseYear = suggestion.releaseDate.toString();
          print(relaseYear);
          if (relaseYear.length > 4) {
            relaseYear = relaseYear.substring(0, 4).toString();
          } else {
            relaseYear = 'Unknown';
          }

          return ListTile(
              contentPadding: EdgeInsets.all(14.0),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MoviesDetails(moviesData[index].posterPath.toString(),
                                moviesData[index].title.toString(),
                                moviesData[index].overview.toString(),
                            moviesData[index].voteAverage.toString(),
                            moviesData[index].releaseDate.toString())));
              },
              // leading: Icon(Icons.autorenew),
              // title: Text(suggestion),
              title: Text(suggestion.title.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              subtitle: Text(
                relaseYear.toString(),
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                suggestion.voteAverage.toString(),
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              leading: FadeInImage(
                image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500/${suggestion.posterPath.toString()}"),
                placeholder: AssetImage("assests/load.png"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assests/warning.png');
                },
              )
          );
        });
  }
}
