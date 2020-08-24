import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_escola/Pages/dashboard_pages/add_trabalho.dart';
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
  RefreshController _refreshControllerTrabalhos = RefreshController(initialRefresh: true);
  List _turmas = [];
  List _trabalhos = [];
  int _i; // Controla que turma foi clicada globalmente
  bool _condition = true;

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

  void _getTrabalhos() async{
    widget.socket.emit('GetTrabalhos', ([widget.token, _turmas[_i]['id']]));

    widget.socket.on('TrabalhosGet', (trabalhosG){
      _trabalhos.clear();
      print(trabalhosG);
      setState(() {
        _trabalhos = trabalhosG;
      });
      _refreshControllerTrabalhos.refreshCompleted();
      widget.socket.off('TrabalhosGet');
    });
  }


  @override
  Widget build(BuildContext context) {
    return _condition ? Scaffold(
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
                        setState(() {
                          _i = index;
                          _condition = false;
                        });
                        _getTrabalhos(); // Ao mudar de widget a função não
                        // executa como deveria através do widget de refresh
                        // por isso chamamos a função aqui para os trabalhos
                        // serem carregados
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _condition = true;
              _refreshController.requestRefresh();
            });
          },
        ),
        centerTitle: true,
        title: Text("Trabalhos"),
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddTrabalho(socket: widget.socket, token: widget.token, turma: _turmas[_i]['id'],))).then((value) => setState(() {
            _refreshControllerTrabalhos.requestRefresh();
          }));
        },
        tooltip: "Adicionar Trabalho",
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.amberAccent,
      ),
      body:SmartRefresher(
        controller: _refreshControllerTrabalhos,
        enablePullDown: true,
        header: WaterDropHeader(),
        onRefresh: _getTrabalhos,
        child: ListView.builder(
          itemCount: _trabalhos.length,
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
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text(_trabalhos[index]['nomeTrabalho']),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                      bottom: 3.0,
                    ),
                    child: Text("Descrição: ${_trabalhos[index]['descricaoTurma']}\n"
                        "Nível: ${_trabalhos[index]['nivelTrabalho']}"),
                  ),
                ) ,
              ),
            );
          },
        ),
      ),
    );
  }
}

