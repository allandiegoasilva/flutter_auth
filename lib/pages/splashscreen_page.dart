

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/pages/home_page.dart';
import 'package:flutter_auth/pages/login_page.dart';


import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key); 

  @override 
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override 
  void initState(){
    super.initState(); 

    verificarToken().then((isAuthenticated){
      Navigator.pushReplacement(context, MaterialPageRoute(
                                                   builder: (context) => isAuthenticated ? HomePage() : LoginPage() 
                                                   )
                                );
    }); 
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),  
      ),
    );
  }


  Future<bool> verificarToken() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance(); 

    return sharedPreference.getString('token') != null;
  }
}