import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TurmaInfos extends StatefulWidget {
  final socket;
  final token;
  final idTurma;

  const TurmaInfos({Key key, this.socket, this.token, this.idTurma}) : super(key: key);

  @override
  _TurmaInfosState createState() => _TurmaInfosState();
}

class _TurmaInfosState extends State<TurmaInfos> {

  RefreshController _refreshController = RefreshController(initialRefresh: true);
  BorderRadiusGeometry radius;
  var nowDay;
  var beforeDay;
  bool hasData = false;
  List<String> xLabel = [];
  List<String> yLabel = [];
  List<FlSpot> trabalhosLine = [];
  List<FlSpot> mediaLine = [];

  void _getData() async{

    widget.socket.emit('GetDataInfo', ([widget.token, widget.idTurma, nowDay, beforeDay]));
    setState(() {
      hasData = false;
    });
    widget.socket.on('DataInfoGet', (dados){
      setState(() {

        xLabel.clear();
        yLabel.clear();
        trabalhosLine.clear();
        mediaLine.clear();

        var labels = dados.keys.toList();
        int yMaior = 5;
        List xTrabalhoLine = [];
        List yTrabalhoLine = [];
        List xNivelLine = [];
        List yNivelLine = [];

        for(int i = labels.length - 1; i >= 0; i--){
          xLabel.add(Jiffy(labels[i], "yyy-MM-dd").local().day.toString());
          int trabalhosLength = dados[labels[i]]['trabalhos'].length;
          int mediaLine = dados[labels[i]]['nivelMedia'];
          if(trabalhosLength > yMaior){
            yMaior = trabalhosLength;
          }
          yTrabalhoLine.add(trabalhosLength.toDouble());
          yNivelLine.add(mediaLine.toDouble());
        }

        for(int i = 0; i <= yMaior; i++){
          yLabel.add(i.toString());
        }

        for(int i = 0; i < labels.length; i++){
          xTrabalhoLine.add(i.toDouble());
          xNivelLine.add(i.toDouble());
        }

        for(int i = 0; i < xTrabalhoLine.length; i++){
          trabalhosLine.add(FlSpot(xTrabalhoLine[i], yTrabalhoLine[i]));
          mediaLine.add(FlSpot(xNivelLine[i], yNivelLine[i]));
        }

        hasData = true;

      });
      widget.socket.off('DataInfoGet');
    });
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    nowDay = Jiffy().format('yyy-MM-dd').toString(); // Dia atual
    beforeDay = Jiffy(nowDay, 'yyy-MM-dd').subtract(days: 6).toString().split(' ')[0]; // 7 dias de diferença inicialmente

    _getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Estatísticas"),
        backgroundColor: Colors.tealAccent,
      ),
      body: Stack(
        children: [

          SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: WaterDropHeader(),
            onRefresh: _getData,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 16.0,
                    top: 72.0,
                  ),
                  child: hasData ? LineChart(
                    data7Days(),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                  ) : null,
                ),
              ],
            ),
          ),

          SlidingUpPanel(
            backdropEnabled: true,
            borderRadius: radius,
            color: Colors.black54,
            collapsed: Container(
              decoration: BoxDecoration(
                  borderRadius: radius
              ),
              child: Center(
                child: Image.asset("imagens/line.png", height: 70.0,),
              ),
            ),
            panelBuilder: (ScrollController sc) => _scrollingList(sc),
            /*panel: Container(
              child: ListView(
                children: [
                  // Informações detalhadas
                ],
              ),
            ),*/
          )
        ],
      ),
    );
  }

  LineChartData data7Days() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return xLabel[value.toInt()];
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return yLabel[value.toInt()];
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: xLabel.length.toDouble() - 1, // Quantidade de colunas no X
      maxY: yLabel.length.toDouble() - 1, // Quantidade de linhas no y
      minY: 0,
      lineBarsData: linesBarData7Days(),
    );
  }

  List<LineChartBarData> linesBarData7Days() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: mediaLine,
      isCurved: true,
      curveSmoothness: 0,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: trabalhosLine,
      isCurved: true,
      curveSmoothness: 0,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(show: false),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }
}


// Este Widget Cria a lista dentro do Slide Up
Widget _scrollingList(ScrollController sc){
  return ListView.builder(
    controller: sc,
    itemCount: 1,
    itemBuilder: (BuildContext context, int i){
      return Padding(
        padding: const EdgeInsets.all(58.0),
        child: Text("$i"),
      );
    },
  );
}