import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TurmaInfos extends StatefulWidget {
  final socket;
  final token;
  final idTurma;

  const TurmaInfos({Key key, this.socket, this.token, this.idTurma}) : super(key: key);

  @override
  _TurmaInfosState createState() => _TurmaInfosState();
}

class _TurmaInfosState extends State<TurmaInfos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Estatísticas"),
        backgroundColor: Colors.tealAccent,
      ),
      body: Stack(
        children: [

          ListView(
            children: [
              // Página principal
            ],
          ),

          SlidingUpPanel(
            color: Colors.black54,
            collapsed: Container(
              child: Center(
                child: Image.asset("imagens/line.png", height: 70.0,),
              ),
            ),
            panel: Container(
              child: ListView(
                children: [
                  // Informações detalhadas
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
