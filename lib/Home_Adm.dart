import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'NewUser.dart';
import 'PersonalData.dart';
import 'Disable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Natação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeADM(),
      routes: {
        '/NewUser': (context) => RegistrationPage(),
        '/Desabilitado': (context) => disable(),
      },
    );
  }
}

class HomeADM extends StatefulWidget {
  @override
  _HomeADMState createState() => _HomeADMState();
}

class _HomeADMState extends State<HomeADM> {
  String userName = "";
  String userType = "";
  String currentTime = '';
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });

    fetchUserData();
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Erro ao realizar o logout: $e");
    }
  }

  void fetchUserData() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        signOut();
      }
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users_authentication')
          .doc(user.uid)
          .get();

      setState(() {
        userName = snapshot['name'];
        print(userName);
        userType = snapshot['type'];
        print(userType);
      });
    }
  }

  Widget athleteDetailsCard(Map<String, dynamic> athleteData) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalhes do Atleta",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            if (athleteData['Nome'] != null)
              Text(
                "Nome: ${athleteData['Nome']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['CPF'] != null)
              Text(
                "CPF: ${athleteData['CPF']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Data_Nascimento'] != null)
              Text(
                "Data de Nascimento: ${athleteData['Data_Nascimento']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Sexo'] != null)
              Text(
                "Sexo: ${athleteData['Sexo']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Endereco'] != null)
              Text(
                "Endereço: ${athleteData['Endereco']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Telefone'] != null)
              Text(
                "Telefone: ${athleteData['Telefone']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Nome_Mae'] != null)
              Text(
                "Nome da Mãe: ${athleteData['Nome_Mae']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Nome_Pai'] != null)
              Text(
                "Nome do Pai: ${athleteData['Nome_Pai']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Cidadania'] != null)
              Text(
                "Cidadania: ${athleteData['Cidadania']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['RG'] != null)
              Text(
                "RG: ${athleteData['RG']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Alérgenos_Medicais'] != null)
              Text(
                "Alergia a Medicamentos: ${athleteData['Alérgenos_Medicais']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Localidade_Nascimento'] != null)
              Text(
                "Local de Nascimento: ${athleteData['Localidade_Nascimento']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Plano_de_Saúde'] != null)
              Text(
                "Plano de Saúde: ${athleteData['Plano_de_Saúde']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Clube_Origem'] != null)
              Text(
                "Clube de Origem: ${athleteData['Clube_Origem']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Estilos_Praticados'] != null)
              Text(
                "Estilo: ${athleteData['Estilos_Praticados']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Lugar_de_Trabalho'] != null)
              Text(
                "Local de Trabalho: ${athleteData['Lugar_de_Trabalho']}",
                style: TextStyle(fontSize: 16),
              ),
            if (athleteData['Testes_Realizados'] != null)
              Text(
                "Testes Realizados: ${athleteData['Testes_Realizados']}",
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAthleteDetails(String athleteId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> athleteSnapshot =
          await FirebaseFirestore.instance
              .collection('atletas')
              .doc(athleteId)
              .get();

      if (athleteSnapshot.exists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: athleteDetailsCard(athleteSnapshot.data() ?? {}),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Fechar"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Atleta não encontrado com o ID: $athleteId",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Fechar"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Erro ao buscar detalhes do atleta",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Fechar"),
              ),
            ],
          );
        },
      );
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat.Hms().format(now);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    fetchUserData();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      appBar: AppBar(
        title: Text('Administração'),
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
                  'Novo Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/NewUser');
                },
              ),
              ListTile(
                title: Text(
                  'Definir Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/Desabilitado');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Informe o ID',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        fillColor: Colors.blueGrey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String athleteId = _searchController.text;
                      fetchAthleteDetails(athleteId);
                    },
                    color: Colors.white,
                    splashColor: Colors.transparent,
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchResults.clear();
                      });
                    },
                    color: Colors.white,
                    splashColor: Colors.transparent,
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
