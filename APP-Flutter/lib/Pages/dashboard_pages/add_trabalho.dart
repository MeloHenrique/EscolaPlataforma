import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_score_slider/flutter_score_slider.dart';

class AddTrabalho extends StatefulWidget {
  final socket;
  final token;
  final turma;

  const AddTrabalho({Key key, this.socket, this.token, this.turma}) : super(key: key);

  @override
  _AddTrabalhoState createState() => _AddTrabalhoState();
}

class _AddTrabalhoState extends State<AddTrabalho> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeTrabalho = TextEditingController();
  TextEditingController _descricaoTrabalho = TextEditingController();
  int _nivelTrabalho = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Trabalho'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Builder(
        builder: (context) => ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.only(
                      top: 32.0,
                    ),
                    child: Center(
                      child: Image.asset("imagens/report128.png"),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: 55.0,
                        left: 32.0,
                        right: 32.0
                    ),
                    child: TextFormField(
                      validator: (texto){
                        if(texto.length <= 3){
                          return "O nome do trabalho é demasiado curto";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _nomeTrabalho,
                      decoration: InputDecoration(
                        labelText: "Nome do Trabalho",
                        hintText: "Trabalho 1",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: 32.0,
                        left: 32.0,
                        right: 32.0
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      validator: (texto){
                        return null;
                      },
                      controller: _descricaoTrabalho,
                      decoration: InputDecoration(
                        labelText: "Descrição do Trabalho",
                        hintText: "Neste Campo pode adicionar \numa descrição sobre o trabalho.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35.0,
                      right: 32.0,
                      left: 32.0
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Dificuldade: $_nivelTrabalho",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.5,
                            ),
                            child: ScoreSlider(
                              thumbColor: Colors.white,
                              scoreDotColor: Colors.white,
                              backgroundColor: Colors.amberAccent.withOpacity(0.70),
                              score: 1,
                              minScore: 1,
                              maxScore: 5,
                              onScoreChanged: (newScore) {
                                setState(() {
                                  _nivelTrabalho = newScore;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 35,
                    ),
                    child: RaisedButton(
                      child: Text("Criar Trabalho"),
                      color: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          // Enviar Token
                        }
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
