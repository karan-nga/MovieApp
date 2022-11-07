import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/reuse/reuseWidget.dart';
 import 'package:movie/screens/login.dart';


class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assests/register.png',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          reusableTextField(
                              "Enter your name", Icons.person, false, name),
                          SizedBox(
                            height: 30,
                          ),
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
                          SizedBox(
                            height: 40,
                          ),
                          firebaseUIButton(context, "Register", () {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (email.text.isEmpty) {
                              snackbar(context, "Please enter mail");
                            }
                            // reg expression for email validation
                            else if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(email.text)) {
                              snackbar(context, "Please Enter a valid email");
                            }

                           else if (pass.text.isEmpty) {
                              snackbar(context, "Please enter password");
                            }
                           else if (!regex.hasMatch(pass.text)) {
                              snackbar(context, "please enter minimum 6 length password");
                            }
                             else {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text, password: pass.text)
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyLogin(),
                                  ),
                                      (route) => false,
                                );
                              }).onError((error, stackTrace) {
                                snackbar(context, error.toString());
                                print(error.toString());
                              });
                            }
                          })
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
