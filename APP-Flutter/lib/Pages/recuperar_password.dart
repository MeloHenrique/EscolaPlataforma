import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:projeto_escola/Pages/registar.dart';
import 'package:projeto_escola/funcoes/crypt.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as rf;
import 'dart:async';

class RecuperarPass extends StatefulWidget {
  final email;
  final socket;

  RecuperarPass({Key key, @required this.email, @required this.socket}) : super(key: key);

  @override
  _RecuperarPassState createState() => _RecuperarPassState();
}

class _RecuperarPassState extends State<RecuperarPass> {
  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final CountdownController controller = CountdownController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _repass = TextEditingController();
  bool _recuperarConfirm = false;
  int _secs = 300;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();

    widget.socket.on("ResetPassConfirmado", (_) {
      if(mounted) {
        setState(() {
          _recuperarConfirm = true;
        });
      }
    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Recuperar Password"),
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: Builder(
        builder: (context) => ListView(
          children: [
            FlareLoading(
              name: "imagens/email_sent.flr",
              loopAnimation: "start",
              startAnimation: "start",
              isLoading: true,
              alignment: Alignment.center,
              height: 200.0,
              width: 300.0,
            ),

            Countdown(
              controller: controller,
              seconds: _secs,
              build: (BuildContext context, double time) => Text("Expira em " + time.toStringAsFixed(0) + " segundos.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              interval: Duration(seconds: 1),
              onFinished: () {
                textEditingController = TextEditingController();
                var alertStyle = rf.AlertStyle(
                  animationType: rf.AnimationType.fromTop,
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

                rf.Alert(
                  context: context,
                  style: alertStyle,
                  type: rf.AlertType.error,
                  title: "O tempo Expirou",
                  desc: "O tempo Expirou. \n Voçê pode reenviar o email ou fazer login.",
                  buttons: [
                    !_recuperarConfirm ? rf.DialogButton(
                      child: Text(
                        "Reenviar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.restart();
                          _recuperarConfirm = false;
                        });
                        widget.socket.emit("ResetPassAgain", (widget.email));
                        Navigator.pop(context);
                      },
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                    ) : rf.DialogButton(
                      child: Text(
                        "Registar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        widget.socket.off('ResetPassConfirmado');
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Registar(socket: widget.socket,)));
                        },
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                    ),
                    rf.DialogButton(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        widget.socket.off('ResetPassConfirmado');
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context, CupertinoPageRoute(builder: (context) =>
                            Login(socket: widget.socket,)));

                      },
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                    )
                  ],
                ).show();
              },
            ),

            !_recuperarConfirm ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 8.0
                  ),
                  child: Text("Foi enviado um email com o código de segurança"
                      " para o adereço: " + widget.email, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0,),),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 24.0,
                      right: 24.0
                  ),
                  child: PinCodeTextField(
                    length: 5,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      selectedColor: Colors.orangeAccent,
                      shape: PinCodeFieldShape.circle,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) {
                      widget.socket.emit("ConfirmResetPass", ([widget.email, v]));
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: RaisedButton(
                    child: Text("Reenviar"),
                    color: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)
                    ),
                    onPressed: () async{
                      setState(() {
                        controller.restart();
                      });
                      widget.socket.emit("ResetPassAgain", (widget.email));
                    }, //On pressed Login
                  ),
                ),

              ],
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKeyPass,
                  child: Column(
                    children: <Widget>[
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
                            labelText: "Nova Password",
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
                            if(texto.length <= 0){
                              return "Verifique a password";
                            }
                            else if(texto != _pass.text){
                              return "As passwords têm de ser iguais!";
                            }
                            else{
                              return null;
                            }
                          },
                          controller: _repass,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Nova Password",
                            hintText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          top: 24.0,
                          left: 32.0,
                          right: 32.0,
                        ),
                        child: RaisedButton(
                          child: Text("Repor Password"),
                          color: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)
                          ),
                          onPressed: () async{
                            if(_formKeyPass.currentState.validate()){
                              var _passC = await cyptPass(_pass.text);
                              widget.socket.emit('ResetPassConfirmado', [widget.email ,_passC, currentText]);
                              widget.socket.off('ResetPassSucessComplete');
                              widget.socket.off('ResetPassFailErr');

                              widget.socket.on('ResetPassSucessComplete', (_) {
                                widget.socket.off('ResetPassSucessComplete');
                                widget.socket.off('ResetPassFailErr');
                                final snackBar = SnackBar(content: Text('A password foi modificada!'), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 3),);
                                Scaffold.of(context).showSnackBar(snackBar);
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(socket: widget.socket,)));
                                });
                              });
                              widget.socket.on('ResetPassFailErr', (_) {
                                widget.socket.off('ResetPassSucessComplete');
                                widget.socket.off('ResetPassFailErr');
                                final snackBar = SnackBar(content: Text('Ocurreu um erro!'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 3),);
                                Scaffold.of(context).showSnackBar(snackBar);
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(socket: widget.socket,)));
                                });
                              });
                            }
                          }, //On pressed Login
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
