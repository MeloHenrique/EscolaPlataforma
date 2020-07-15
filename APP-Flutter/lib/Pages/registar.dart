import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:projeto_escola/funcoes/crypt.dart';
import 'package:string_validator/string_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Registar extends StatefulWidget {
  final socket;

  Registar({Key key, @required this.socket}) : super(key: key);

  @override
  _RegistarState createState() => _RegistarState();
}

class _RegistarState extends State<Registar> {

  TextEditingController _nome = TextEditingController();
  TextEditingController _apelido = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _passv = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          Form(
            key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 36.0,
                        left: 24.0,
                        right: 24.0
                    ),
                    child: TextFormField(
                      validator: (texto) {
                        if(!isAlpha(texto) || texto.length <= 0){
                          return "Verifique o nome";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _nome,
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
                    child: TextFormField(
                      validator: (texto) {
                        if(!isAlpha(texto) || texto.length <= 0){
                          return "Verifique o apelido";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _apelido,
                      decoration: InputDecoration(
                        labelText: "Apelido",
                        hintText: "Apelido",
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (texto) {
                        if(!EmailValidator.validate(texto)) {
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
                        if(_pass.text.length < 6) {
                          return "A password é demasiado curta";
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
                        top: 28.0,
                        left: 24.0,
                        right: 24.0
                    ),
                    child: TextFormField(
                      validator: (texto) {
                        if(_pass.text != texto || texto.length <= 0) {
                          return "As passwords não coincidem";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _passv,
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
                        child: Text("Registar"),
                        color: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)
                        ),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){

                            var _passC = await cyptPass(_pass.text);

                            widget.socket.emit("Registar", ([_nome.text, _apelido.text, _email.text, _passC, _passv.text]));

                            //Enviar Socket => (Importante)
                          }
                        }, //On pressed Registar
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
