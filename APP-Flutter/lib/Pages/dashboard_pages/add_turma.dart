import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../dashboard.dart';

class AddTurma extends StatefulWidget {
  final socket;
  final token;

  const AddTurma({Key key, this.socket, this.token}) : super(key: key);


  @override
  _AddTurmaState createState() => _AddTurmaState();
}

class _AddTurmaState extends State<AddTurma> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeTurma = TextEditingController();
  TextEditingController _numeroAlunos = TextEditingController();
  TextEditingController _nomeDisciplina = TextEditingController();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return num.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar turma"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(
                      top: 32.0,
                    ),
                    child: Center(
                      child: Image.asset("imagens/teaching.png"),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 28.0,
                      left: 32.0,
                      right: 32.0
                    ),
                    child: TextFormField(
                      validator: (texto){
                        if(texto.length <= 3){
                          return "O nome da turma é demasiado curto";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _nomeTurma,
                      decoration: InputDecoration(
                        labelText: "Nome da Turma",
                        hintText: "Nome da Turma",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 18.0,
                      left: 32.0,
                      right: 32.0
                    ),
                    child: TextFormField(
                      validator: (texto){
                        if(texto.length <= 0){
                          return "É necessário preencher este campo.";
                        }
                        else if(!isNumeric(texto)){
                          return "Alguma coisa não está bem";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _numeroAlunos,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Número de alunos",
                        hintText: "10",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 18.0,
                        left: 32.0,
                        right: 32.0
                    ),
                    child: TextFormField(
                      validator: (texto){
                        if(texto.length <= 3){
                          return "O nome da disciplina é demasiado curto";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _nomeDisciplina,
                      decoration: InputDecoration(
                        labelText: "Disciplina",
                        hintText: "Disciplina",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            widget.socket.emit("AddTurma", ([widget.token, _nomeTurma.text, _numeroAlunos.text, _nomeDisciplina.text]));

                            widget.socket.on("TurmaCriada", (criada) {
                              if(criada){
                                final snackBar = SnackBar(content: Text('Turma Criada!'), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 3),);
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                              else{
                              final snackBar = SnackBar(content: Text('A sua conta já tem uma turma com esse nome!'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 3),);
                              Scaffold.of(context).showSnackBar(snackBar);
                              }
                              widget.socket.off('TurmaCriada');
                            });

                          }
                        },
                        child: Text("Adicionar Turma"),
                        color: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
