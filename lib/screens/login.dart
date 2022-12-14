import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/reuse/reuseWidget.dart';
import 'package:movie/screens/movies.dart';
import 'package:movie/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  String? errorMessage;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assests/login.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Login',
            style: TextStyle(fontSize: 25.0, color: Colors.black,fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 100),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.amber, fontSize: 33,fontWeight: FontWeight.w500),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.33),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          reusableTextField("Enter your email",
                              Icons.person_outline, false, email),
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextField(
                              "Enter your password", Icons.lock, true, pass),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              firebaseUIButton(context, "Login", () async {
                                if (email.text.isEmpty) {
                                  snackbar(context, "Please enter mail");
                                }
                                // reg expression for email validation
                                else if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(email.text)) {
                                  snackbar(
                                      context, "Please Enter a valid email");
                                } else if (pass.text.isEmpty) {
                                  snackbar(context, "Please enter password");
                                } else {

                                  SharedPreferences preference =
                                      await SharedPreferences.getInstance();
                                  preference.setString('email', email.text);

                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email.text,
                                          password: pass.text)
                                      .then((value) {
                                    snackbar(context, "Login successful");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Movies(),
                                      ),
                                      (route) => false,
                                    );
                                  }).onError((error, stackTrace) {
                                    snackbar(context, error.toString());
                                    print(error.toString());
                                  });
                                }
                                {}
                              })
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const Text("Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyRegister(),
                                    ),

                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
