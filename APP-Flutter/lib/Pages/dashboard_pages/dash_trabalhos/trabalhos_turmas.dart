import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class TrabalhosTurmas extends StatefulWidget {
  final socket;
  final token;
  final Function(String) openTrabalhos;

  const TrabalhosTurmas({Key key, this.socket, this.token, this.openTrabalhos}) : super(key: key);

  @override
  _TrabalhosTurmasState createState() => _TrabalhosTurmasState();
}

class _TrabalhosTurmasState extends State<TrabalhosTurmas> {

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
        backgroundColor: Colors.tealAccent,
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
                          widget.openTrabalhos(_turmas[index]['id']);
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

