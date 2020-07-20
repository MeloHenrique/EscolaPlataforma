import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/recuperar_password.dart';
import 'package:projeto_escola/Pages/registar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:projeto_escola/funcoes/crypt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<SharedPreferences> _token = SharedPreferences.getInstance();

  Future<void> _tokenSet(newToken) async {
    final SharedPreferences token = await _token;
    setState(() {
      token.setString("token", newToken);
    });
  }

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
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          var _passC = await cyptPass(_pass.text);
                          widget.socket.emit("Login", ([_email.text, _passC]));
                          widget.socket.off("PassErrada");
                          widget.socket.off("NenhumEmail");
                          widget.socket.off("LoginConcluido");
                          widget.socket.on("LoginConcluido", (token){
                            _tokenSet(token);
                            //Enviar para a dashboard
                          });
                          widget.socket.on("NenhumEmail", (_){
                            var alertStyle = AlertStyle(
                              animationType: AnimationType.fromTop,
                              isCloseButton: false,
                              isOverlayTapDismiss: false,
                              descStyle: TextStyle(fontSize: 14.0),
                              animationDuration: Duration(milliseconds: 400),
                              alertBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              titleStyle: TextStyle(
                                color: Colors.red,
                              ),
                            );

                            Alert(
                              context: context,
                              style: alertStyle,
                              type: AlertType.info,
                              title: "Conta não existe",
                              desc: "Essa conta não existe. \n Voçê pode criar uma conta ou continuar.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Criar",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Registar(socket: widget.socket,)));
                                    },
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                                DialogButton(
                                  child: Text(
                                    "Continuar",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                )
                              ],
                            ).show();
                          });

                          widget.socket.on("PassErrada", (_){
                            var alertStyle = AlertStyle(
                              animationType: AnimationType.fromTop,
                              isCloseButton: false,
                              isOverlayTapDismiss: false,
                              descStyle: TextStyle(fontSize: 14.0),
                              animationDuration: Duration(milliseconds: 400),
                              alertBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              titleStyle: TextStyle(
                                color: Colors.red,
                              ),
                            );

                            Alert(
                              context: context,
                              style: alertStyle,
                              type: AlertType.error,
                              title: "Password Errada",
                              desc: "A password está errada. \n Voçê pode recuperar a sua password ou continuar.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Recuperar",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    widget.socket.emit("ResetPass", (_email.text));
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => RecuperarPass(email: _email.text, socket: widget.socket,)));
                                  }, //Ir para página para recuperar a password, quando for criada.
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                                DialogButton(
                                  child: Text(
                                    "Continuar",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                )
                              ],
                            ).show();
                          });

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
