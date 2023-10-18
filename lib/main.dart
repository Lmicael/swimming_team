//RF001
// Importando os pacotes necessários do Flutter
import 'package:flutter/material.dart';

// Importando as telas de registro
import 'RF002.dart';
import 'RF003.dart';
import 'RF004.dart';

// Função principal que é o ponto de entrada do aplicativo Flutter
void main() {
  runApp(MyApp());
}

// Classe principal do aplicativo que herda de StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlassEffectWidget(),
      //Rotas para as telas
      routes: {
        '/RF002': (context) => RegistrationPage(),
        '/RF003': (context) => AthleteRegistrationScreen(),
        '/RF004': (context) => TreinoForm(),
      },
    );
  }
}

// Classe de modelo para representar um usuário
class Pessoas {
  String email;
  String senha;
  String tipoUser;

  Pessoas({required this.email, required this.senha, required this.tipoUser});
}

// Widget GlassEffectWidget que é a tela de login
class GlassEffectWidget extends StatelessWidget {
  // Controladores para campos de email e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Pessoas> usuarios = [
    // Lista de usuários predefinidos
    Pessoas(email: "joao@sou.unaerp.edu.br", senha: "12345", tipoUser: "adm"),
    Pessoas(email: "carla@sou.unaerp.edu.br", senha: "45678", tipoUser: "treinador"),
    Pessoas(email: "maria@sou.unaerp.edu.br", senha: "78900", tipoUser: "atleta"),
    Pessoas(email: "luis@sou.unaerp.edu.br", senha: "12345", tipoUser: "adm"),
    Pessoas(email: "wilmar@sou.unaerp.edu.br", senha: "45678", tipoUser: "treinador"),
    Pessoas(email: "steve@sou.unaerp.edu.br", senha: "78900", tipoUser: "atleta")
  ];

  // Função para lidar com a solicitação de redefinição de senha
  void handleForgotPassword(BuildContext context) {
    // Mostra um AlertDialog para inserir o email
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
              child: Text(
                  'Cancelar'), //Fecha o diálogo quando o botão Cancelar é pressionado
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  'Ok'), //Envia o email inserido para o console quando o botão Ok é pressionado
              onPressed: () {
                print('Email inserido: ${emailController.text}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Função para realizar o login
  void login(BuildContext context) {
    String inputEmail = emailController.text;
    String inputPassword = passwordController.text;
    bool isLoggedIn = false;

    //Itera sobre a lista de usuários e verifica as credenciais inseridas
    for (int i = 0; i < usuarios.length; i++) {
      //Navega para a tela correspondente com base no tipo de usuário
      if (usuarios[i].email == inputEmail &&
          usuarios[i].senha == inputPassword) {
        isLoggedIn = true;
        if (usuarios[i].tipoUser == "adm") {
          Navigator.pushNamed(context, '/RF002');
        } else if (usuarios[i].tipoUser == "treinador") {
          Navigator.pushNamed(context, '/RF003');
        } else if (usuarios[i].tipoUser == "atleta") {
          Navigator.pushNamed(context, '/RF004');
        }
        break;
      }
    }

    if (!isLoggedIn) {
      //Mostrar uma mensagem de erro, usuário ou senha incorretos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Incorreto!'),
            content: Text('Email ou senha incorretos!.'),
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

  //Método build para construir a interface do usuário
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Define o fundo da tela como uma imagem
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/Go.jpeg'), //Carrega uma imagem do arquivo assets
                fit:
                    BoxFit.cover, //Ajusta a imagem para cobrir todo o contêiner
              ),
            ),
          ),
          //Conteúdo da tela dentro de um SingleChildScrollView para permitir rolagem quando o teclado está aberto
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 110,
                  ),
                  //Widget de imagem
                  Align(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 220,
                      height: 220,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //Campos de entrada para email e senha
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText:
                          true, //Máscara para esconder o texto da senha
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  //Botão para redefinir a senha
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
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide.none,
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