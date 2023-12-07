import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: disable(),
    );
  }
}

class disable extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<disable> {
  String _selectedStatus = "inativo";
  TextEditingController _codeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      appBar: AppBar(
        title: Text('Primeiro Acesso'),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogoImage(),
              SizedBox(height: 20),
              _buildCodeTextField(),
              SizedBox(height: 20),
              Center(child: _buildStatusDropdown()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Realizar Alteração'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _codeController,
        decoration: InputDecoration(
          labelText: 'Código',
          border: InputBorder.none, 
          contentPadding:
              EdgeInsets.all(16.0), 
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      width: 200,  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white, 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Status:'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
            items: _buildDropdownItems(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return ['inativo', 'ativo'].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  Widget _buildLogoImage() {
    return Image.asset(
      'assets/logo.png',
      width: 200,
      height: 200,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String athleteId = _codeController.text.trim();

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users_authentication')
            .where('ID', isEqualTo: athleteId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          String documentId = documentSnapshot.id;

          await FirebaseFirestore.instance
              .collection('users_authentication')
              .doc(documentId)
              .update({'status': _selectedStatus});

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'O status do usuário foi atualizado para ${_selectedStatus}.'),
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
                content: Text('Usuário não encontrado'),
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
      } catch (error) {
        print('Erro ao atualizar status: $error');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Erro ao atualizar status'),
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
    }
  }
}
