import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrabalhosGeral extends StatefulWidget {
  final socket;
  final token;

  const TrabalhosGeral({Key key, this.socket, this.token}) : super(key: key);

  @override
  _TrabalhosState createState() => _TrabalhosState();
}

class _TrabalhosState extends State<TrabalhosGeral> {

  RefreshController _refreshController = RefreshController(initialRefresh: true);
  List _turmas = [];


  void _getTurmasTrabalhos() async{
    widget.socket.emit('GetTurmasTrabalhos', (widget.token));
    widget.socket.on('turmasTrabalhosGet', (turmasG){
      _turmas.clear();
      setState(() {
        _turmas = turmasG;
      });
      _refreshController.refreshCompleted();
      widget.socket.off('turmasTrabalhosGet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Trabalhos"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(),
        onRefresh: _getTurmasTrabalhos,
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
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(_turmas[index]['nomeTurma']),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                          bottom: 3.0,
                        ),
                        child: Text("Número de Trabalhos: ${_turmas[index]['numeroDeTrabalhos']} \n"
                            "Disciplina: ${_turmas[index]['disciplina']} "),
                      ),
                      onTap: () {
                        print("Tap $index");
                        // vai para uma nova página, onde mostra uma lista com os trabalhos,
                        // utilizar uma variável para mostrar as turmas quando é verdadeira
                        // e mostrar os trabalhos quando é falsa
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
