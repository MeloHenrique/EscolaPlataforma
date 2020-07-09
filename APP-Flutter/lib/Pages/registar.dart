import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/login.dart';

class Registar extends StatefulWidget {
  @override
  _RegistarState createState() => _RegistarState();
}

class _RegistarState extends State<Registar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Registar"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 54.0,
            ),
            child: Center(
              child: Image.asset("imagens/profile.png", height: 120, width: 120,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 36.0,
                left: 24.0,
                right: 24.0
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Nome",
                hintText: "Nome",
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
              child: Text("Registar"),
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
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
              },
              highlightColor: Colors.amberAccent,
              //quando se clica cor amarelo
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white60)
              ),
              child: Text("Login"),
            ),
          )
        ],
      ),
    );
  }
}
