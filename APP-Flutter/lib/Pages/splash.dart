import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:projeto_escola/Pages/dashboard.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<SharedPreferences> _token = SharedPreferences.getInstance();
  bool _loading = true;
  bool _tokenE = false;
  bool _first = true;
  String tokenSt;

  IO.Socket socket = IO.io('http://157.245.44.14:8000', <String, dynamic>{
    'transports': ['websocket']
  });
  Future<void> _tokenF() async {
    final SharedPreferences token = await _token;
    tokenSt = token.getString('token');
    if(token.getString('token') == null){
      setState(() {
        _tokenE = false;
        _loading = false;
      });
    }
    else{
      socket.emit("TokenV", (tokenSt));

      socket.on("TokenVerificado", (_) {
        setState(() {
          _tokenE = true;
          _loading = false;
        });
        socket.off("TokenVerificado");
        socket.off("TokenErro");
      });
      socket.on("TokenErro", (_) {
        token.remove("token");
        setState(() {
          _tokenE = false;
          _loading = false;
        });
        socket.off("TokenVerificado");
        socket.off("TokenErro");
      });
    }

  }

  connectionV() async{
    socket.on("Conectado", (data) {
      _tokenF();
      socket.off("Conectado");
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_first){
      _first = false;
      connectionV();
    }
    return Scaffold(
      body: Center(
        child: SplashScreen.navigate(
          name: 'imagens/school.flr',
          next: (_) {
            if(!_tokenE){
              return Login(socket: socket,);
            }
            else{
              return Dashboard(socket: socket, token: tokenSt,);
            }
          },
          isLoading: _loading,
          loopAnimation: 'Untitled',
          startAnimation: 'Untitled',
        ),
      ),
    );
  }
}
