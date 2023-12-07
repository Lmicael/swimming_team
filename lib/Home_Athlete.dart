import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PersonalData.dart';
import 'TrainingRegistration.dart';
import 'PersonalData_Athlete.dart';
import 'Graphics.dart';
import 'ComparisonChart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Natação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeAthlete(),
      routes: {
        '/PersonalData': (context) => AthleteRegistrationScreen(),
        '/TrainingRegistration': (context) => TreinoForm(),
        '/PersonalData_Athlete': (context) =>
            AthleteRegistrationScreen_Athlete(),
        '/Graphic': (context) => GraphicScreen(),
        '/CompareChart': (context) => ComparisonChart(),
      },
    );
  }
}

class HomeAthlete extends StatefulWidget {
  @override
  _HomeADMState createState() => _HomeADMState();
}

class _HomeADMState extends State<HomeAthlete> {
  String userName = "";
  String userType = "";
  String userID = "";
  String currentTime = '';
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  List<int> apoio = [];

  late Future<QuerySnapshot> treinosFuture;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Erro ao realizar o logout: $e");
    }
  }

  Future<QuerySnapshot> fetchUserData() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        signOut();
      } else {
        print('Logado...');
      }
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users_authentication')
          .doc(user.uid)
          .get();

      userName = snapshot['name'];
      print(userName);
      userType = snapshot['type'];
      print(userType);
      userID = snapshot['ID'];
      print(userID);

      treinosFuture = FirebaseFirestore.instance
          .collection('treinos')
          .doc(userID)
          .collection('sessions')
          .get();
    }
    return treinosFuture;
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat.Hms().format(now);
    return formattedTime;
  }

  void _mostrarDetalhesDialog(
      Map<String, dynamic> treinoData, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes do Treino'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Estilo: ${treinoData['data']}'),
              Text('Estilo: ${treinoData['estiloTreino']}'),
              Text('Responsável: ${treinoData['responsavel']}'),
              Text(
                  'Frequência Cardíaca Início: ${treinoData['frequenciaInicio']}'),
              Text('Frequência Cardíaca Fim: ${treinoData['frequenciaFim']}'),
              Text('Última Volta (m): ${treinoData['mUltimaVolta']}'),
              Text('Numero de Treinos: ${treinoData['numeroTreino']}'),
              Text('Tempos: ${treinoData['tempos']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      appBar: AppBar(
        title: Text('Atleta'),
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
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 3, 5, 56),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  '$userName',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                accountEmail: Text(
                  '$userType',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 5, 56),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text(
                  'Inscrição de Atletas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/PersonalData_Athlete');
                },
              ),
              ListTile(
                title: Text(
                  'Registrar Novo Treino',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/TrainingRegistration',
                      arguments: apoio);
                },
              ),
              ListTile(
                title: Text(
                  'Cronômetro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/StopWatch');
                },
              ),
              ListTile(
                title: Text(
                  'Análise Gráfica',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/Graphic', arguments: userID);
                },
              ),
              ListTile(
                title: Text(
                  'Análise Comparativa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/CompareChart', arguments: userID);
                },
              ),
              SizedBox(
                height: 320,
              ),
              ListTile(
                title: Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  signOut();
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            currentTime,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar os treinos.');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('Nenhum treino encontrado.');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var treino = snapshot.data!.docs[index];
                      var treinoData = treino.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text('${treinoData['data']}'),
                          subtitle:
                              Text('Responsável: ${treinoData['responsavel']}'),
                          onTap: () {
                            _mostrarDetalhesDialog(treinoData, context);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
