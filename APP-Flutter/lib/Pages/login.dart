import 'package:flutter/material.dart';

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
              child: Image.asset("imagens/logo_login.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 48.0,
              left: 16.0,
              right: 16.0
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
                left: 16.0,
                right: 16.0
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
        ],
      ),
    );
  }
}
