import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/registar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 64.0,
            ),
            child: Center(
              child: Image.asset("imagens/logo_login.png", height: 120, width: 120,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 48.0,
              left: 24.0,
              right: 24.0
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 28.0,
                left: 24.0,
                right: 24.0
            ),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 36.0,
                left: 64.0,
                right: 64.0,
              ),
            child: RaisedButton(
              child: Text("Login"),
              color: Colors.amberAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)
              ),
              onPressed: () => {}, //On pressed Login
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 64.0,
              right: 64.0,
            ),
            child: FlatButton(
              onPressed: () {
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Registar()));
                },
              highlightColor: Colors.amberAccent,
              //quando se clica cor amarelo
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white60)
              ),
              child: Text("Registar"),
            ),
          )
        ],
      ),
    );
  }
}
