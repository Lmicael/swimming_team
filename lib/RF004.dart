import 'package:flutter/material.dart';
import 'RF005.dart';

void main() => runApp(MyApp());

//Classe para representar um treino avaliativo
class TreinoAvaliativo {
  //Propriedades do treino avaliativo
  String estilo;
  int numeroTreino;
  String idAtleta;
  DateTime data;
  int frequenciaCardiacaInicio;
  int frequenciaCardiacaFim;
  List<int> tempos;
  String responsavel;

  //Construtor para inicializar as propriedades
  TreinoAvaliativo({
    required this.estilo,
    required this.numeroTreino,
    required this.idAtleta,
    required this.data,
    required this.frequenciaCardiacaInicio,
    required this.frequenciaCardiacaFim,
    required this.tempos,
    required this.responsavel,
  });

  @override
  String toString() {
    //Método para converter o objeto em uma string formatada
    return 'Estilo: $estilo, Número do Treino: $numeroTreino, ID do Atleta: $idAtleta, Data: $data, Frequência Cardíaca Inicial: $frequenciaCardiacaInicio, Frequência Cardíaca Final: $frequenciaCardiacaFim, Tempos: $tempos, Responsável: $responsavel';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino Avaliativo App',
      home: TreinoForm(),
    );
  }
}

//Classe para o formulário de treino
class TreinoForm extends StatefulWidget {
  @override
  _TreinoFormState createState() => _TreinoFormState();
}

class _TreinoFormState extends State<TreinoForm> {
  //Chave global para o formulário
  final _formKey = GlobalKey<FormState>();

  //Controladores para os campos de entrada
  TextEditingController estiloController = TextEditingController();
  TextEditingController numeroTreinoController = TextEditingController();
  TextEditingController idAtletaController = TextEditingController();
  TextEditingController frequenciaInicioController = TextEditingController();
  TextEditingController frequenciaFimController = TextEditingController();
  TextEditingController temposController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();

  void results(BuildContext context) {
    Navigator.pushNamed(context, '/RF005');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treino Avaliativo'),
        //Cor de fundo da AppBar
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //Campos de entrada para os detalhes do treino
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
                  controller: frequenciaInicioController,
                  decoration:
                      InputDecoration(labelText: 'Frequência Cardíaca Inicial'),
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
                    onPressed: () {
                      // Lógica para validar e registrar o treino
                      if (_formKey.currentState!.validate()) {
                        TreinoAvaliativo treino = TreinoAvaliativo(
                          estilo: estiloController.text,
                          numeroTreino: int.parse(numeroTreinoController.text),
                          idAtleta: idAtletaController.text,
                          data: DateTime.now(),
                          frequenciaCardiacaInicio:
                              int.parse(frequenciaInicioController.text),
                          frequenciaCardiacaFim:
                              int.parse(frequenciaFimController.text),
                          tempos: temposController.text
                              .split(',')
                              .map((e) => int.parse(e))
                              .toList(),
                          responsavel: responsavelController.text,
                        );
                        print('Dados do treino: ${treino.toString()}');
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AvaliacaoList(avaliacoes: avaliacoes)),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text(
                          'Visualizar Resultados',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
