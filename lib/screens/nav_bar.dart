import 'package:flutter/material.dart';
import 'package:movie/reuse/reuseWidget.dart';
import 'package:movie/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  String getEmail='';

  @override
  Widget build(BuildContext context) {
  fun();
    return Drawer(backgroundColor: Color(0xff191826),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(getEmail),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'assests/man.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ), accountName: null,
          ),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.white,size: 23),
            title: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 17)),
            onTap: () async {
              SharedPreferences preference=await SharedPreferences.getInstance();
              preference.remove('email');
              snackbar(context, "Logout Success");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyLogin(),
                ),
                    (route) => false,
              );


            },
          ),

        ],
      ),
    );
  }
  fun() async {
    SharedPreferences preference=await SharedPreferences.getInstance();
    getEmail=preference.getString('email')!;
  }
}