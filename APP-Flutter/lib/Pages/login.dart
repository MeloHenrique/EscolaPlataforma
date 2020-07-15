import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/registar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Login extends StatefulWidget {
  final socket;

  Login({Key key, @required this.socket}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 48.0,
                      left: 24.0,
                      right: 24.0
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (texto) {
                      if(texto.length <= 0 || !EmailValidator.validate(texto)){
                        return "Verifique o Email";
                      }
                      else{
                        return null;
                      }
                    },
                    controller: _email,
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
                  child: TextFormField(
                    validator: (texto) {
                      if(texto.length <= 0){
                        return "Verifique a password";
                      }
                      else{
                        return null;
                      }
                    },
                    controller: _pass,
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
                  ),
                  child: ButtonTheme(
                    minWidth: 160.0,
                    child: RaisedButton(
                      child: Text("Login"),
                      color: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      ),
                      onPressed: (){

                        if(_formKey.currentState.validate()){
                          //Enviar Socket => (Importante)
                        }

                        if(_email.text != ""){
                          if(_pass.text != ""){
                            if(EmailValidator.validate(_email.text)){
                              //enviar socket.io do login
                            }
                            else{
                              // não é um email
                            }
                          }
                          else{
                            // nada escrito na pass
                          }
                        }
                        else{
                          // nada escrito no email
                        }
                      }, //On pressed Login
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: 36.0,
                  ),
                  child: ButtonTheme(
                    minWidth: 160.0,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Registar(socket: widget.socket,)));
                      },
                      highlightColor: Colors.amberAccent,
                      //quando se clica cor amarelo
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white60)
                      ),
                      child: Text("Registar"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
