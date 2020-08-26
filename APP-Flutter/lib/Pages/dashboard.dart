import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projeto_escola/Pages/dashboard_pages/dash_trabalhos/trabalhos_dash.dart';
import 'package:projeto_escola/Pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_pages/turmas.dart';

class Dashboard extends StatefulWidget {
  final socket;
  final token;

  const Dashboard({Key key, this.socket, this.token}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool verificadoToken = false;
  bool _first = true;
  List<Widget> _paginas;

  verificarToken(){
    widget.socket.emit("TokenV", (widget.token));

    widget.socket.on("TokenVerificado", (_) {
      setState(() {
        verificadoToken = true;
      });
      widget.socket.off("TokenVerificado");
      widget.socket.off("TokenErro");
    });

    widget.socket.on("TokenErro", (_) async{
      Future<SharedPreferences> _token = SharedPreferences.getInstance();
      final SharedPreferences token = await _token;
      token.remove('token');
      widget.socket.off("TokenVerificado");
      widget.socket.off("TokenErro");
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(socket: widget.socket,)));
    });

  }

  @override
  Widget build(BuildContext context) {
    if(_first){
      _first = false;
      _paginas = [
        TrabalhosDash(socket: widget.socket, token: widget.token,),
        TurmasPagina(socket: widget.socket, token: widget.token,),
        TurmasPagina(socket: widget.socket, token: widget.token,)
      ];
      verificarToken();
    }
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 55.0,
        items: <Widget>[
          Icon(Icons.class_, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.amberAccent,
        buttonBackgroundColor: Colors.amberAccent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),

      body: verificadoToken ? _paginas[_page] : Container(),
    );
  }
}
