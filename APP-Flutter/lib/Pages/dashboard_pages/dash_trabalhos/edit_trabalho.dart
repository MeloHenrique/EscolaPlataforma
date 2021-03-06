import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_score_slider/flutter_score_slider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditTrabalho extends StatefulWidget {
  final socket;
  final token;
  final idTrabalho;
  final turma;

  const EditTrabalho({Key key, this.socket, this.token, this.idTrabalho, this.turma}) : super(key: key);

  @override
  _EditTrabalhoState createState() => _EditTrabalhoState();
}

class _EditTrabalhoState extends State<EditTrabalho> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeTrabalho = TextEditingController();
  TextEditingController _descricaoTrabalho = TextEditingController();
  int _nivelTrabalho = 1;
  bool _nomeSelected = false;
  bool _descricaoSelected = false;
  bool _scoreSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Trabalho"),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: Builder(
        builder: (context) => ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 32.0,
              ),
              child: Center(
                child: Image.asset("imagens/report128.png"),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 55.0,
                        left: 32.0,
                        right: 32.0
                    ),
                    child: Container(
                      child: Row(
                        children: [
                         CircularCheckBox(
                            value: _nomeSelected,
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              inactiveColor: Colors.redAccent,
                              disabledColor: Colors.grey,
                            onChanged: (val) => setState(() {_nomeSelected = !_nomeSelected;}),
                          ),

                          Expanded(
                            child: TextFormField(
                              enabled: _nomeSelected,
                              validator: (texto){
                                if(texto.length <= 3 && _nomeSelected){
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
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: 32.0,
                        left: 32.0,
                        right: 32.0
                    ),

                    child: Container(
                      child: Row(
                        children: [
                          CircularCheckBox(
                            value: _descricaoSelected,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            inactiveColor: Colors.redAccent,
                            disabledColor: Colors.grey,
                            onChanged: (val) => setState(() {_descricaoSelected = !_descricaoSelected;}),
                          ),

                          Expanded(
                            child: TextFormField(
                              enabled: _descricaoSelected,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                              validator: (texto){
                                if(texto.length <= 3 && _descricaoSelected){
                                  return "A descrição é demasiado curta";
                                }
                                else{
                                  return null;
                                }
                              },
                              controller: _descricaoTrabalho,
                              decoration: InputDecoration(
                                labelText: "Descrição do Trabalho",
                                hintText: "Neste Campo pode adicionar \numa descrição sobre o trabalho.",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
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
                      child: Row(
                        children: [
                          CircularCheckBox(
                            value: _scoreSelected,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            inactiveColor: Colors.redAccent,
                            disabledColor: Colors.grey,
                            onChanged: (val) => setState(() {_scoreSelected = !_scoreSelected;}),
                          ),

                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _scoreSelected ? Text(
                                    "Dificuldade: $_nivelTrabalho",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ) : Text(
                                    "O nível não será modificado!",
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.5,
                                    ),
                                    child: ScoreSlider(
                                      thumbColor: Colors.white,
                                      scoreDotColor: Colors.white,
                                      backgroundColor: Colors.tealAccent.withOpacity(0.70),
                                      score: _nivelTrabalho,
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
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 35,
                    ),
                    child: RaisedButton(
                      child: Text("Editar Trabalho", style: TextStyle(color: Colors.black54),),
                      color: Colors.tealAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          var editTrabalho = {};
                          if(_nomeSelected){
                            editTrabalho["nomeTrabalhoEdit"] = _nomeTrabalho.text;
                          }
                          if(_descricaoSelected){
                            editTrabalho["descricaoTrabalhoEdit"] = _descricaoTrabalho.text;
                          }
                          if(_scoreSelected){
                            editTrabalho["ScoreTrabalhoEdit"] = _nivelTrabalho;
                          }
                          if(editTrabalho.length > 0){
                            widget.socket.emit('EditarTrabalho', ([widget.token, widget.idTrabalho, editTrabalho]));

                            widget.socket.on('TrabalhoEditar', (_){
                              if(_){
                                final snackBar = SnackBar(content: Text('Trabalho Editado!'), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 1),);
                                Scaffold.of(context).showSnackBar(snackBar);
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                });
                              }
                              else{
                                final snackBar = SnackBar(content: Text('Ocorreu um erro!'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 2),);
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                              widget.socket.off('TrabalhoEditar');
                            });

                            editTrabalho.clear();
                          }
                          else{
                            final snackBar = SnackBar(content: Text('Não selecionou nenhum campo!'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 2),);
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: RaisedButton(
                      child: Text("Eliminar Trabalho", style: TextStyle(color: Colors.black54),),
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)
                      ),
                      onPressed: (){

                        var alertStyle = AlertStyle(
                          animationType: AnimationType.fromTop,
                          isCloseButton: false,
                          isOverlayTapDismiss: true,
                          descStyle: TextStyle(fontSize: 14.0),
                          animationDuration: Duration(milliseconds: 400),
                          alertBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          titleStyle: TextStyle(
                            color: Colors.redAccent,
                          ),
                        );

                        Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.info,
                          title: "Eliminar Trabalho",
                          desc: "Está prestes a eliminar o trabalho.\n"
                              "Não será possível recuperar o trabalho.",
                          buttons: [
                            DialogButton(
                              child: Text("Cancelar"),
                              color: Colors.black54,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            DialogButton(
                              child: Text("Eliminar"),
                              color: Colors.redAccent,
                              onPressed: () {
                                widget.socket.emit('DeleteTrabalho', ([widget.token, widget.idTrabalho, widget.turma]));

                                widget.socket.on('TrabalhoDelete', (_){
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  widget.socket.off('TrabalhoDelete');
                                });

                              },
                            ),
                          ],
                        ).show();

                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
