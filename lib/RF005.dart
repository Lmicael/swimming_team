//Importando os pacotes necessários do Flutter
import 'package:flutter/material.dart';
import 'dart:math';

//Definindo a classe TreinoAvaliativo para representar os dados do treino
class TreinoAvaliativo {
  String estilo;
  int numeroTreino;
  String idAtleta;
  DateTime data;
  int frequenciaCardiacaInicio;
  int frequenciaCardiacaFim;
  List<int> tempos;
  String responsavel;

  //Construtor para inicializar os dados do treino
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
}

//Lista de avaliações de treino inicializada com dados de exemplo
List<TreinoAvaliativo> avaliacoes = [
  TreinoAvaliativo(
    estilo: 'Teste 1',
    numeroTreino: 1,
    idAtleta: "1780",
    data: DateTime.now(),
    frequenciaCardiacaInicio: 25,
    frequenciaCardiacaFim: 45,
    tempos: [45],
    responsavel: "Teste Responsável 1",
  ),
  TreinoAvaliativo(
    estilo: 'Teste 2',
    numeroTreino: 2,
    idAtleta: "1058",
    data: DateTime.now(),
    frequenciaCardiacaInicio: 28,
    frequenciaCardiacaFim: 31,
    tempos: [45, 10, 25],
    responsavel: "Teste Responsável 2",
  ),
  TreinoAvaliativo(
    estilo: 'Teste 3',
    numeroTreino: 3,
    idAtleta: "1058",
    data: DateTime.now(),
    frequenciaCardiacaInicio: 32,
    frequenciaCardiacaFim: 38,
    tempos: [45, 10, 25],
    responsavel: "Teste Responsável 2",
  ),
];

//Função principal para iniciar o aplicativo Flutter
void main() => runApp(MyApp());

//Classe MyApp que define o widget principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Resultados dos Treinos Avaliativos'), //Título da barra de aplicativos
        ),
        body: AvaliacaoList(
            avaliacoes:
                avaliacoes), //Corpo do aplicativo contendo a lista de avaliações
      ),
    );
  }
}

//Classe AvaliacaoList que define o widget para exibir a lista de avaliações de treino
class AvaliacaoList extends StatelessWidget {
  final List<TreinoAvaliativo> avaliacoes;

  //Construtor para inicializar a lista de avaliações
  AvaliacaoList({required this.avaliacoes});

  //Função para gerar cores aleatórias para os cartões
  List<Color> generateRandomColors(int numberOfColors) {
    Random random = Random();
    List<Color> colors = [];

    for (int i = 0; i < numberOfColors; i++) {
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);
      colors.add(Color.fromARGB(255, red, green, blue));
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: avaliacoes.length,
      itemBuilder: (context, index) {
        List<Color> randomColors = generateRandomColors(100);
        int randomIndex = Random().nextInt(randomColors.length);

        //Construindo o cartão para cada avaliação de treino
        return Card(
          color:
              randomColors[randomIndex], //Cor de fundo aleatória para o cartão
          child: ListTile(
            title: Text(
              'ID do Atleta: ${avaliacoes[index].idAtleta}',
              style: TextStyle(color: Colors.white), //Cor do texto branco
            ),
            subtitle: Text(
              //Exibindo os detalhes da avaliação de treino
              'Data: ${avaliacoes[index].data.toString()}\nNúmero do Treino: ${avaliacoes[index].numeroTreino}\nEstilo: ${avaliacoes[index].estilo}\nFrequência Cardíaca no Início: ${avaliacoes[index].frequenciaCardiacaInicio}\nFrequência Cardíaca no Fim: ${avaliacoes[index].frequenciaCardiacaFim}\nTempos: ${avaliacoes[index].tempos}\nResponsável: ${avaliacoes[index].responsavel}',
              style: TextStyle(color: Colors.white), //Cor do texto branco
            ),
          ),
        );
      },
    );
  }
}
