import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/models/searchModel.dart';
import 'package:movie/repo/search_data.dart';

import '../../const/constants.dart';
import '../../reuse/reuseWidget.dart';

class MoviesFind extends StatefulWidget {
  @override
  State<MoviesFind> createState() => _MoviesFindState();
}

class _MoviesFindState extends State<MoviesFind> {
  @override
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
              final result = showSearch(
                  context: context, delegate: MoviesDelegate());
            },
          )
        ],
      ),

    );
  }
}

class MoviesDelegate extends SearchDelegate<String> {
  List<Result> moviesData = [];

  Future<List<Result>> searchMovie(String name) async {
    http.Response response;
    name.replaceAll(' ', '');
    response = await http.get(Uri.parse('${ApiConstants.SearchUrl}+$name'));
    if (response.statusCode == 200) {
      final moviesResult = searchModelFromJson(response.body);
      moviesData = moviesResult.results;

      print(moviesData.toString());
    } else {
      print('Request failed with status :${response.statusCode}');
    }
    return moviesData;
  }

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, query);
            }
            else {
              query = '';
            }
          },
        )
      ];


  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, query),
      );


  @override
  Widget buildResults(BuildContext context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 120),
            const SizedBox(height: 40),
            Text(
              query,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 64
              ),
            ),
          ],

        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) =>
      FutureBuilder<List<Result>>(
        future: searchMovie(query.replaceAll(' ', '')),
        builder: (context, snapshot) {
          if (query.isEmpty) return noSearch();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError || snapshot.data!.isEmpty) {
                return noResult();
              }
              else {
                return buildSuggestionsSuccess(snapshot.data!);
              }
          }
        },
      );

  Widget noSearch() {
    return Center(
      child: Text("Search your movies", style: TextStyle(
          fontSize: 28,
          color: Colors.amber
      )),

    );
  }
  Widget noResult() {
    return Center(
      child: Text("Unable to find make sure name is correct", style: TextStyle(
          fontSize: 28,
          color: Colors.amber
      )),

    );
  }

  Widget buildSuggestionsSuccess(List<Result> suggestions) {

    return ListView.builder(
        itemCount: suggestions.isEmpty!=true?suggestions.length:0,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          String relaseYear = suggestion.releaseDate.toString();
          print(relaseYear);
          if(relaseYear.length>4){
            relaseYear=relaseYear.substring(0,4).toString();
          }
          else{
            relaseYear='Unknown';
          }


          return ListTile(
              contentPadding: EdgeInsets.all(14.0),
              onTap: () {
                query = suggestion.originalTitle.trim();
                showResults(context);
              },
              // leading: Icon(Icons.autorenew),
              // title: Text(suggestion),
              title: Text(
                suggestion.title.toString(),style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )
              ),
              subtitle: Text(
                relaseYear,
                  style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                suggestion.voteAverage.toString(),
                style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),
              ),
              leading:  FadeInImage(
                image: NetworkImage("https://image.tmdb.org/t/p/w500/${suggestion.posterPath}"),
                placeholder: AssetImage(
                    "assests/load.png"),
                imageErrorBuilder:
                    (context, error, stackTrace) {
                  return Image.asset(
                      'assests/warning.png'
                     );
                },

              )
          );
        }
    );
  }


}

