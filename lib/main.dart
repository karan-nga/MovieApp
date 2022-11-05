
import 'package:flutter/material.dart';
import 'package:movie/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/screens/movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preference=await SharedPreferences.getInstance();
  var email=preference.getString('email');
  runApp(MaterialApp(
    home:email==null?MyLogin():Movies(),
    debugShowCheckedModeBanner: false,

  ));
}
