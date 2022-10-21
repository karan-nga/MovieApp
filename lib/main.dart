
import 'package:flutter/material.dart';
import 'package:movie/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/screens/register.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
     initialRoute: 'login',
    routes: {
      'login':(context)=> MyLogin(),
    'register':(context)=>MyRegister()
    },
  ));
}
