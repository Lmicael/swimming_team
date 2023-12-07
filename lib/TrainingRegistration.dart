import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino Avaliativo',
      home: TreinoForm(),
    );
  }
}

class TreinoForm extends StatefulWidget {
  @override
  _TreinoFormState createState() => _TreinoFormState();
}

class _TreinoFormState extends State<TreinoForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController estiloController = TextEditingController();
  TextEditingController numeroTreinoController = TextEditingController();
  TextEditingController idAtletaController = TextEditingController();
  TextEditingController frequenciaInicioController = TextEditingController();
  TextEditingController frequenciaFimController = TextEditingController();
  TextEditingController temposController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController mUltimaVoltaController = TextEditingController();

  Future<void> adicionarTreinoAoFirestore({
    required TextEditingController idAtletaController,
    required TextEditingController estiloController,
    required TextEditingController numeroTreinoController,
    required TextEditingController frequenciaInicioController,
    required TextEditingController frequenciaFimController,
    required TextEditingController temposController,
    required TextEditingController responsavelController,
    required TextEditingController dataController,
    required TextEditingController mUltimaVoltaController,
  }) async {
    try {
      if (idAtletaController.text.isEmpty ||
          estiloController.text.isEmpty ||
          numeroTreinoController.text.isEmpty ||
          frequenciaInicioController.text.isEmpty ||
          frequenciaFimController.text.isEmpty ||
          temposController.text.isEmpty ||
          responsavelController.text.isEmpty ||
          dataController.text.isEmpty ||
          mUltimaVoltaController.text.isEmpty) {
        return;
      }

      Map<String, dynamic> formData = {
        'idAtleta': idAtletaController.text,
        'estiloTreino': estiloController.text,
        'numeroTreino': int.parse(numeroTreinoController.text),
        'frequenciaInicio': int.parse(frequenciaInicioController.text),
        'frequenciaFim': int.parse(frequenciaFimController.text),
        'tempos':
            temposController.text.split(',').map((e) => int.parse(e)).toList(),
        'responsavel': responsavelController.text,
        'data': dataController.text,
        'mUltimaVolta': double.parse(mUltimaVoltaController.text),
      };

      await FirebaseFirestore.instance
          .collection('treinos')
          .doc(idAtletaController.text)
          .collection('sessions')
          .doc()
          .set(formData);

      idAtletaController.clear();
      estiloController.clear();
      numeroTreinoController.clear();
      frequenciaInicioController.clear();
      frequenciaFimController.clear();
      temposController.clear();
      responsavelController.clear();
      dataController.clear();
      mUltimaVoltaController.clear();
    } catch (error) {
      print('Erro ao adicionar treino: $error');
    }
  }

  Future<bool> checkIfFolderExists(String folderPath) async {
    try {
      Reference reference = FirebaseStorage.instance.ref(folderPath);
      await reference.listAll(); 
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _cadastrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        WidgetsFlutterBinding.ensureInitialized();

        String folderPath = idAtletaController.text;
        bool folderExists = await checkIfFolderExists(folderPath);

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('atletas')
            .doc(idAtletaController.text)
            .get();

        if (userSnapshot.exists && folderExists == true) {
          await adicionarTreinoAoFirestore(
            idAtletaController: idAtletaController,
            estiloController: estiloController,
            numeroTreinoController: numeroTreinoController,
            frequenciaInicioController: frequenciaInicioController,
            frequenciaFimController: frequenciaFimController,
            temposController: temposController,
            responsavelController: responsavelController,
            dataController: dataController,
            mUltimaVoltaController: mUltimaVoltaController,
          );

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text('Treino cadastrado com sucesso!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'O usuário informado não possui todas as informações cadastradas. Impossível realizar o cadastro do treino!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Erro ao cadastrar usuário: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> pauses = ModalRoute.of(context)!.settings.arguments as List<int>;
    temposController.text = pauses.join(',');

    return Scaffold(
      appBar: AppBar(
        title: Text('Treino Avaliativo'),
        backgroundColor: Color.fromARGB(255, 3, 5, 56),
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: idAtletaController,
                    decoration: InputDecoration(labelText: 'ID do Atleta'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira o ID do atleta';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: estiloController,
                    decoration: InputDecoration(labelText: 'Estilo do Treino'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira o estilo do treino';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: numeroTreinoController,
                    decoration: InputDecoration(labelText: 'Número do Treino'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira o número do treino';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: frequenciaInicioController,
                    decoration: InputDecoration(
                        labelText: 'Frequência Cardíaca Inicial'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira a frequência cardíaca inicial';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: frequenciaFimController,
                    decoration:
                        InputDecoration(labelText: 'Frequência Cardíaca Final'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira a frequência cardíaca final';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: temposController,
                    decoration: InputDecoration(
                        labelText: 'Tempos (separados por vírgula)'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira os tempos';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: responsavelController,
                    decoration: InputDecoration(
                        labelText: 'Responsável pelo Controle do Tempo'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira o responsável';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dataController,
                    decoration: InputDecoration(labelText: 'Data do Treino'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira a data do treino';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: mUltimaVoltaController,
                    decoration: InputDecoration(
                        labelText:
                            'Quantidade de metros percorrida na última volta'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira a quantidade de metros percorrida na última volta';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          const Color.fromARGB(255, 18, 114, 158)
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _cadastrarUsuario();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: Text(
                            'Registrar',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          const Color.fromARGB(255, 18, 114, 158)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
