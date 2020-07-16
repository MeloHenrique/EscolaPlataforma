import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:projeto_escola/funcoes/crypt.dart';
import 'package:string_validator/string_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
        title: Text("Registar"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => ListView(
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
                              widget.socket.off("RegistarExiste");
                              widget.socket.off("RegistarConcluido");
                              widget.socket.on("RegistarConcluido", (token) {
                                final snackBar = SnackBar(content: Text('A sua conta foi registada!'), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 3),);
                                _tokenSet(token);
                                Scaffold.of(context).showSnackBar(snackBar);
                                //Redirecionar para a dashboard quando acabar
                              });
                              widget.socket.on("RegistarExiste", (vazio) {

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
                                  title: "Conta Existente",
                                  desc: "A conta que está a tentar registar já existe. \n Voçê pode recuperar a sua password ou continuar.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Recuperar",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context), //Ir para página para recuperar a password, quando for criada.
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
                            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(socket: widget.socket,)));
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
      ),
    );
  }
}
