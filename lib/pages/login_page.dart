
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key }) : super(key: key); 

  @override 
  _LoginPageState createState() => _LoginPageState(); 
}


class _LoginPageState extends State<LoginPage> {

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Digite o seu e-mail"
                  ),
                  validator: (email) {

                    if(email == null || email.isEmpty)
                      return "Informe o e-mail.";

                    else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text))
                      return "Informe um e-mail válido."; 

                    return null;  
                  },
                ), 
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Digite a sua senha"
                  ),
                  validator: (pass){
                    if(pass == null || pass.isEmpty)
                      return "Informe uma senha.";

                    else if(pass.length < 6)
                        return "Quantidade de caracteres inválidos.";
                        
                    return null; 
                  },
                ),
                ElevatedButton(onPressed: () async {

                  FocusScopeNode currentFocus = FocusScope.of(context); 

                  // Verifica o estado atual do formulário perante as validações realizadas em 
                  // cada TextFormFIeld 
                  if(!_formkey.currentState!.validate())
                    return; 


                  bool credentials_valid = await login(); 

                  if(currentFocus.hasPrimaryFocus)
                    currentFocus.unfocus(); 
                  
                  if(credentials_valid)
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  else{
                    _passwordController.clear(); 

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } 
                 }, child: Text("Entrar"), ),
              ],
            ),
          ),
        )
      ) 
    );
  }

  final snackBar = SnackBar(content: Text(
      "E-mail ou Senha inválidos.", textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  Future<bool> login() async {
    SharedPreferences sharedePreferences = await SharedPreferences.getInstance(); 



    // CREDENCIAIS FIXAS PARA TESTES. OBS: NUNCA FAZER ISSO PARA UM APP DE VDD.  
    String email = "test@email.com";
    String senha = "123456";
    String _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZW1haWwuY29tIiwicGFzc3dvcmQiOiIxMjM0NTYiLCJuYW1lIjoiVGVzdGVyIiwiam9iIjoiU29mdHdhcmUgZW5naW5lciJ9.xnc9YpUHtakbQDdTG-Gxg78qZSwuc7jAbG6g7yqfxkM"; 

    bool credentials_valid = _emailController.text == email && _passwordController.text == senha; 

    var url = Uri.parse("https://6307db283a2114bac76ce575.mockapi.io/users"); 
    var response = await http.post(url, 
      body: {
        "username": _emailController.text, 
        "password": _passwordController.text 
      } 
    );

    if(response.statusCode == 200){

      var data = jsonDecode(response.body); 

      print(data);
    }

    if(credentials_valid){
      await sharedePreferences.setString("token", "Bearer $_token");
    }

    return credentials_valid; 
  }
}