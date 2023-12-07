import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GraphicScreen(),
    );
  }
}

class GraphicScreen extends StatefulWidget {
  const GraphicScreen({Key? key}) : super(key: key);

  @override
  _GraphicScreenState createState() => _GraphicScreenState();
}

class _GraphicScreenState extends State<GraphicScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<double> allTempos = [];
  List<Atleta> atletas = [];
  List<Atleta> average = [];
  String? Id_Atleta = '';
  double? averageTime;
  List<double> belowAverage = [];
  List<double> aboveAverage = [];

  @override
  void initState() {
    super.initState();

    getTempoValues();
  }

  Future<void> getTempoValues() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('treinos').get();
      Set<double> uniqueTempos = Set();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        QuerySnapshot subCollection = await _firestore
            .collection('treinos')
            .doc(Id_Atleta)
            .collection('sessions')
            .get();
        print(subCollection);

        for (QueryDocumentSnapshot subDocument in subCollection.docs) {
          List<dynamic> tempoList = subDocument['tempos'];
          uniqueTempos.addAll(tempoList.map((tempo) => tempo.toDouble()));
        }
      }

      double total = 0;
      int count = 0;

      for (double tempo in uniqueTempos) {
        total += tempo;
        count++;
      }

      if (count > 0) {
        averageTime = total / count;

        setState(() {
          allTempos = List.from(uniqueTempos);
          atletas = [Atleta(allTempos)];
          average = [
            Atleta([averageTime!])
          ];
        });

        double belowAverageThreshold = averageTime! * 0.8;
        belowAverage =
            allTempos.where((tempo) => tempo <= belowAverageThreshold).toList();

        double aboveAverageThreshold = averageTime! * 1.2;
        aboveAverage =
            allTempos.where((tempo) => tempo >= aboveAverageThreshold).toList();

        print("Média: $averageTime");
        print("Valores abaixo da média até 80%: $belowAverage");
        print("Valores acima da média até 120%: $aboveAverage");
      }
    } catch (e) {
      print('Erro ao obter valores de tempo: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? ID =
        (ModalRoute.of(context)!.settings.arguments as String?) ?? '';
    Id_Atleta = ID;

    return Scaffold(
      appBar: AppBar(
        title: Text('Análise Gráfica'),
        backgroundColor: Color.fromARGB(255, 3, 5, 56),
        elevation: 8,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          children: [
            LineChart(LineChartData(
              minY: 0,
              maxY: 50,
              minX: 0,
              maxX: 10,
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: const AxisTitles(
                  axisNameWidget: Text("Voltas (M)"),
                  sideTitles: SideTitles(showTitles: true),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: const Text("Tempo (min)"),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getLeftTitles,
                  ),
                ),
              ),
              lineBarsData: [
                if (atletas.isNotEmpty)
                  LineChartBarData(
                    spots: atletas[0]
                        .tempos
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value))
                        .toList(),
                  ),
                if (average.isNotEmpty)
                  LineChartBarData(
                    spots: average[0]
                        .tempos
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value))
                        .toList(),
                    color: Colors.red,
                    dotData: FlDotData(show: true),
                  ),
                if (belowAverage.isNotEmpty)
                  LineChartBarData(
                    spots: belowAverage
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value))
                        .toList(),
                    color: Colors.green,
                    dotData: FlDotData(show: true),
                  ),
                if (aboveAverage.isNotEmpty)
                  LineChartBarData(
                    spots: aboveAverage
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value))
                        .toList(),
                    color: Color.fromARGB(255, 166, 33, 243),
                    dotData: FlDotData(show: true),
                  ),
              ],
            )),
            Positioned(
              top: 8,
              left: MediaQuery.of(context).size.width - 300,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem("Azul: Tempo dos Treinos", Colors.blue),
                    _buildLegendItem("Vermelho: Média", Colors.red),
                    _buildLegendItem(
                        "Verde: Abaixo da média até 80%", Colors.green),
                    _buildLegendItem("Roxo: Acima da média até 120%",
                        Color.fromARGB(255, 166, 33, 243)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    int minutes = value ~/ 60;
    int seconds = (value % 60).toInt();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        "$minutes:$seconds",
        softWrap: false,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class Atleta {
  List<double> tempos;
  Atleta(this.tempos);
}
