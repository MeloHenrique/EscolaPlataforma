import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/dashboard_pages/add_turma.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TurmasPagina extends StatefulWidget {
  final socket;
  final token;

  const TurmasPagina({Key key, this.socket, this.token}) : super(key: key);

  @override
  _TurmasPaginaState createState() => _TurmasPaginaState();
}

class _TurmasPaginaState extends State<TurmasPagina> {
  RefreshController _refreshController = RefreshController(initialRefresh: true);

  List _turmas = [];

  void _getTurmas() async{
    widget.socket.emit("GetTurmas", (widget.token));

    widget.socket.on('turmasGet', (turmasR) {
      _turmas.clear();
      setState(() {
        _turmas = turmasR;
      });
      _refreshController.refreshCompleted();
      widget.socket.off('turmasGet');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Turmas"),
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddTurma(socket: widget.socket, token: widget.token,)));
        },
        tooltip: "Adicionar Turma",
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.amberAccent,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(),
        onRefresh: _getTurmas,
        child: ListView.builder(
          itemCount: _turmas.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     ListTile(
                      leading: Icon(Icons.supervisor_account),
                      title: Text(_turmas[index]['nomeTurma']),
                      trailing: Icon(Icons.arrow_forward_ios),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                          bottom: 3.0,
                        ),
                        child: Text("Número de alunos: ${_turmas[index]['numeroDeAlunos']} \n"
                            "Disciplina: ${_turmas[index]['disciplina']} "),
                      ),
                      onTap: () {
                        print("Tap $index"); // vai para uma nova página, onde mostra o gráfico
                      },
                      onLongPress: () {
                        print("Long Press $index"); // vai para uma página onde pode editar a turma se o email for válido
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}