import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool _loading = true;

  IO.Socket socket = IO.io('http://157.245.44.14:8000', <String, dynamic>{
    'transports': ['websocket']
  });

  connectionV() async{
    socket.on("Conectado", (data) {
      setState(() {
        _loading = false;
      });
      socket.off("Conectado");
    });
  }

  @override
  Widget build(BuildContext context) {
    connectionV();
    return Scaffold(
      body: Center(
        child: SplashScreen.navigate(
          name: 'imagens/school.flr',
          next: (_) => Login(socket: socket,),
          isLoading: _loading,
          loopAnimation: 'Untitled',
          startAnimation: 'Untitled',
        ),
      ),
    );
  }
}
