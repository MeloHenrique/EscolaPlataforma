import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/dashboard_pages/dash_trabalhos/trabalhos.dart';
import 'package:projeto_escola/Pages/dashboard_pages/dash_trabalhos/trabalhos_turmas.dart';

class TrabalhosDash extends StatefulWidget {
  final socket;
  final token;

  const TrabalhosDash({Key key, this.socket, this.token}) : super(key: key);

  @override
  _TrabalhosDashState createState() => _TrabalhosDashState();
}

class _TrabalhosDashState extends State<TrabalhosDash> {

  int index = 0;
  String turma;
  bool _first = true;

  nextIndex(turmaValor){
    print(turmaValor);
    setState(() {
      turma = turmaValor;
      _paginas = [
        TrabalhosTurmas(socket: widget.socket, token: widget.token, openTrabalhos: nextIndex,),
        Trabalhos(socket: widget.socket, token: widget.token, turma: turma, backTurmas: backIndex,)
      ];
      index = 1;
    });
  }

  backIndex(){
    setState(() {
      turma = "";
      _paginas = [
        TrabalhosTurmas(socket: widget.socket, token: widget.token, openTrabalhos: nextIndex,),
        Trabalhos(socket: widget.socket, token: widget.token, turma: turma, backTurmas: backIndex,)
      ];
      index = 0;
    });
  }

  List<Widget> _paginas;

  @override
  Widget build(BuildContext context) {
    if(_first){
      _first = false;
      _paginas = [
        TrabalhosTurmas(socket: widget.socket, token: widget.token, openTrabalhos: nextIndex,),
        Trabalhos(socket: widget.socket, token: widget.token, turma: turma, backTurmas: backIndex,)
      ];
    }
    return _paginas[index];
  }
}