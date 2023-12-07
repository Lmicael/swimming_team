import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: arquivo(),
    );
  }
}

class arquivo extends StatefulWidget {
  @override
  _ArquivoState createState() => _ArquivoState();
}

class _ArquivoState extends State<arquivo> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  TextEditingController _folderController = TextEditingController();
  List<String> fileNames = [];

  Future<void> listFiles() async {
    String path = _folderController.text;

    try {
      firebase_storage.ListResult result = await storage.ref(path).listAll();

      setState(() {
        fileNames = result.items.map((ref) => ref.name).toList();
      });

      if (fileNames.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Pasta não encontrada'),
              content: Text('A pasta informada não foi encontrada.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Erro ao listar arquivos: $e');
    }
  }

  Future<void> downloadFile(String fileName) async {
    String path = _folderController.text + '/' + fileName;
    try {
      final Directory systemTempDir = Directory.systemTemp;
      final File tempFile = File('${systemTempDir.path}/$fileName');

      await storage.ref(path).writeToFile(tempFile);

      if (await tempFile.exists()) {
        print('Download concluído: ${tempFile.path}');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Download Concluído'),
              content: Text('O arquivo foi baixado com sucesso.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Erro: Arquivo não encontrado após o download.');
      }
    } catch (e) {
      print('Erro ao fazer download do arquivo: $e');

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro no Download'),
            content: Text('Ocorreu um erro ao baixar o arquivo.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      appBar: AppBar(
        title: Text('Consulta de Arquivos'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _folderController,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                labelText: 'ID do Atleta',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                listFiles();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 3, 5, 56),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              child: Text(
                'Consultar Arquivos',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            if (fileNames.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: fileNames.length,
                  itemBuilder: (context, index) {
                    final fileName = fileNames[index];
                    return ListTile(
                      title: Text(fileName),
                      trailing: ElevatedButton(
                        onPressed: () {
                          downloadFile(fileName);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 3, 5, 56),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Text(
                          'Download',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
