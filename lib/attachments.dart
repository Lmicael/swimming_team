import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AttachmentScreen(),
    );
  }
}

class AttachmentScreen extends StatefulWidget {
  @override
  _AttachmentScreenState createState() => _AttachmentScreenState();
}

class _AttachmentScreenState extends State<AttachmentScreen> {
  List<File?> _images = List.generate(6, (index) => null);
  bool _showSuccessMessage = false;

  static const List<String> filePrefixes = [
    'atestado_medico',
    'rg',
    'cpf',
    'comprovante_residencia',
    'foto_3x4',
    'regulamento_assinado',
  ];

  Future<void> _showUploadDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Concluído'),
          content: Text('Todos os arquivos foram carregados com sucesso.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future _getImageFromGallery(int index) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images[index] = File(image.path);
      });

      if (_images[index] != null) {
        print('Arquivo anexado com sucesso: ${_images[index]!.path}');
      } else {
        print('Falha ao anexar o arquivo');
      }
    }
  }

  Future<void> _uploadFiles(String folderName) async {
    try {
      for (int i = 0; i < _images.length; i++) {
        if (_images[i] != null) {
          final fileName ='${filePrefixes[i]}.jpg';

          final firebase_storage.Reference reference = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('$folderName/$fileName');

          await reference.putFile(_images[i]!);

          print('Arquivo $i enviado com sucesso.');
        }
      }

      if (_images.every((image) => image == null)) {
        print('Nenhum arquivo selecionado.');
        return;
      }

      setState(() {
        _showSuccessMessage = true;
      });

      await _showUploadDialog();
    } catch (e) {
      print('Erro ao enviar arquivos: $e');
    }
  }

  ElevatedButton buildElevatedButton(String text, int index) {
    return ElevatedButton(
      onPressed: () => _getImageFromGallery(index),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        primary: _images[index] != null ? Colors.green : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? ID = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Anexar Arquivos'),
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
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            buildElevatedButton('Atestado Médico Admissional', 0),
            SizedBox(height: 12),
            buildElevatedButton('RG', 1),
            SizedBox(height: 12),
            buildElevatedButton('CPF', 2),
            SizedBox(height: 12),
            buildElevatedButton('Comprovante de Residência', 3),
            SizedBox(height: 12),
            buildElevatedButton('Foto 3X4', 4),
            SizedBox(height: 12),
            buildElevatedButton('Regulamento Assinado', 5),
            SizedBox(height: 70),
            ElevatedButton(
              onPressed: () => _uploadFiles(ID!),
              child: Text('Finalizar Cadastro'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
