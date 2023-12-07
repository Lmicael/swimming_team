import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  String? Id_Atleta = '';
  String? idAtleta;

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

        for (QueryDocumentSnapshot subDocument in subCollection.docs) {
          List<dynamic> tempoList = subDocument['tempos'];
          uniqueTempos.addAll(tempoList.map((tempo) => tempo.toDouble()));
        }
      }

      setState(() {
        allTempos = List.from(uniqueTempos);
        atletas = [Atleta(allTempos)];
      });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Código do Atleta',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                getTempoValues();
              },
              child: Text('Consultar'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(LineChartData(
                minY: 0,
                maxY: 80,
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
                lineBarsData: atletas
                    .map((e) => LineChartBarData(
                          spots: e.tempos
                              .asMap()
                              .entries
                              .map((entry) =>
                                  FlSpot(entry.key.toDouble(), entry.value))
                              .toList(),
                        ))
                    .toList(),
              )),
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
}

class Atleta {
  List<double> tempos;
  Atleta(this.tempos);
}
