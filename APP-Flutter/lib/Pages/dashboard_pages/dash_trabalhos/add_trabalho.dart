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
  DateTime selectedDate = DateTime.now();
  int _nivelTrabalho = 1;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Trabalho'),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
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
                    padding: EdgeInsets.only(
                      top: 35.0,
                      left: 32.0,
                      right: 32.0,
                    ),
                    child: Row(
                      children: [
                        RaisedButton(
                          onPressed: () => _selectDate(context), // Refer step 3
                          child: Text(
                            'Mudar data do trabalho',
                          ),
                          color: Colors.tealAccent.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)
                          ),
                        ),

                        SizedBox(
                          width: 20.0,
                        ),

                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
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
                              backgroundColor: Colors.tealAccent.withOpacity(0.70),
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
                      child: Text("Criar Trabalho", style: TextStyle(color: Colors.black54),),
                      color: Colors.tealAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          widget.socket.emit('AddTrabalho', ([widget.token, widget.turma, _nomeTrabalho.text, _descricaoTrabalho.text, "${selectedDate.toLocal()}".split(' ')[0], _nivelTrabalho]));

                          widget.socket.on('TrabalhoCriado', (_){
                            if(_){
                              final snackBar = SnackBar(content: Text('Trabalho Criado!'), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 3),);
                              Scaffold.of(context).showSnackBar(snackBar);
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                            }
                            else{
                              final snackBar = SnackBar(content: Text('Ocorreu um problema!'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 3),);
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                            widget.socket.off('TrabalhoCriado');
                          });

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
