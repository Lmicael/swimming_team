import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'Home_Adm.dart';
import 'Home_Trainer.dart';
import 'Home_Athlete.dart';
import 'NewUser.dart';
import 'PersonalData.dart';
import 'TrainingRegistration.dart';
import 'stopwatch.dart';
import 'First_Access.dart';
import 'Disable.dart';
import 'PersonalData_Athlete.dart';
import 'attachments.dart';
import 'ConsultDoc.dart';
import 'ConsultDoc_Athlete.dart';
import 'Graphics.dart';
import 'ComparisonChart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/NewUser': (context) => RegistrationPage(),
        '/PersonalData': (context) => AthleteRegistrationScreen(),
        '/TrainingRegistration': (context) => TreinoForm(),
        '/Home_Adm': (context) => HomeADM(),
        '/Home_Trainer': (context) => HomeTrainer(),
        '/Home_Athlete': (context) => HomeAthlete(),
        '/StopWatch': (context) => stopwatch(),
        '/First_Access': (context) => PrimeiroAcessoScreen(),
        '/Desabilitado': (context) => disable(),
        '/PersonalData_Athlete': (context) => AthleteRegistrationScreen_Athlete(),
        '/Attachments': (context) => AttachmentScreen(),
        '/Teste': (context) => arquivo(),
        '/ConsultDoc_Athlete': (context) => arquivo_athlete(),
        '/Graphic': (context) => GraphicScreen(),
        '/CompareChart': (context) => ComparisonChart(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handleForgotPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Esqueceu a senha?'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'E-Mail'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await _auth.sendPasswordResetEmail(
                      email: emailController.text,
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Aviso'),
                          content: Text(
                            'Se o e-mail fornecido estiver em nosso banco de dados, você receberá um e-mail com instruções para redefinir sua senha. Por favor, verifique também sua caixa de spam.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Erro'),
                          content: Text(
                              'Erro ao enviar o e-mail de recuperação de senha. Verifique se o e-mail está correto e tente novamente.'),
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
              },
            ),
          ],
        );
      },
    );
  }

  void login(BuildContext context) async {
    String inputEmail = emailController.text;
    String inputPassword = passwordController.text;

    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campo vazio'),
            content: Text('Por favor, preencha todos os campos.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: inputEmail,
        password: inputPassword,
      );

      User? user = userCredential.user;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users_authentication')
          .doc(user?.uid)
          .get();

      if (userSnapshot.exists) {
        String userType = userSnapshot.get('type');
        String status = userSnapshot.get('status');

        if (status == 'ativo') {
          if (userType == 'Administrador') {
            Navigator.pushReplacementNamed(context, '/Home_Adm');
          } else if (userType == 'Treinador') {
            Navigator.pushReplacementNamed(context, '/Home_Trainer');
          } else if (userType == 'Atleta') {
            Navigator.pushReplacementNamed(context, '/Home_Athlete');
          }
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'O usuário está marcado como inativo, portanto, não será possível realizar o login.'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Inválido'),
              content: Text(
                  'Email informado não está registrado na base de dados\nSe o erro persistir, procurar o administrador do aplicativo!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Incorreto!'),
            content: Text('Email ou senha incorretos!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Go.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 110),
                  Image.asset(
                    'assets/logo.png',
                    width: 220,
                    height: 220,
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        handleForgotPassword(context);
                      },
                      child: Text(
                        'Esqueceu a Senha?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/First_Access');
                      },
                      child: Text('Primeiro Acesso'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
