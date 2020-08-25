import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'file:///C:/Users/Henrique/Documents/projeto_escola/lib/Pages/dashboard_pages/trabalhos_stack/add_trabalho.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Trabalhos extends StatefulWidget {
  final socket;
  final token;
  final Function() backTurmas;
  final turma;

  const Trabalhos({Key key, this.socket, this.token, this.backTurmas, this.turma}) : super(key: key);

  @override
  _TrabalhosState createState() => _TrabalhosState();
}

class _TrabalhosState extends State<Trabalhos> {

  RefreshController _refreshControllerTrabalhos = RefreshController(initialRefresh: true);
  List _trabalhos = [];
  bool _edit = false;

  void _getTrabalhos() async{
    widget.socket.emit('GetTrabalhos', ([widget.token, widget.turma]));
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.5,
            ),
            child: Container(
                child: InkWell(
                  child: _edit ? Icon(Icons.close) : Icon(Icons.edit),
                  onTap: () {
                    if(_edit){
                      setState(() {
                        _edit = false;
                      });
                    }
                    else{
                      setState(() {
                        _edit = true;
                      });
                    }
                  },
                )
            ),
          )
        ],
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.backTurmas();
          },
        ),
        centerTitle: true,
        title: Text("Trabalhos"),
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddTrabalho(socket: widget.socket, token: widget.token, turma: widget.turma,))).then((value) => setState(() {
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
                  trailing: _edit ? Icon(Icons.arrow_forward_ios): null,
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
                  onTap: _edit ? () {
                    // Se estiver no modo de edição vai para a página para
                    // editar o trabalho, é necessário enviar o _id do trabalho
                    // em que clicou
                  }: null,
                ) ,
              ),
            );
          },
        ),
      ),
    );
  }
}
