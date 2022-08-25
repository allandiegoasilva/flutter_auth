
import 'package:flutter/material.dart';
import 'package:flutter_auth/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);  

  @override
  _HomePageState createState() => _HomePageState(); 
}

class _HomePageState extends State<HomePage> {

  @override 

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Sair do App"), 
          onPressed: (){
            logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      )
    );
  }


  Future<void> logout() async { 
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); 
     sharedPreferences.remove("token");      
  }
}