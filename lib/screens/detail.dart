import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/booking.dart';
import 'package:transparent_image/transparent_image.dart';

import '../reuse/reuseWidget.dart';

class MoviesDetails extends StatelessWidget {
  final String poster;
  final String nameMovie;
  final String overview;
  final String rating;
  final String releaseData;

  MoviesDetails(this.poster, this.nameMovie, this.overview, this.rating,
      this.releaseData);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height / 3),
          child: SafeArea(
            child: AppBar(
              title: Text(nameMovie),
              backgroundColor: Colors.blue,
              flexibleSpace: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: "https://image.tmdb.org/t/p/w500$poster",
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assests/warning.png');
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(

            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                nameMovie,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),

               Text("Overview",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,)),
              SizedBox(height: 10,),
              Text(
                overview,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 1.0, right: 1.0),
                  ),
                  Text(

                    "Rating:" + rating,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),

                ],
              ),
              Row(
               verticalDirection: VerticalDirection.down,
                children: [
                  firebaseUIButton(context,"Book Ticket",(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MovieBooking(),
                      ),

                    );
                  })
                ],
              )
            ],

          ),

        ));
  }
}
