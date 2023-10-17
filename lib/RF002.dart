//Importando o pacote/material Flutter
import 'package:flutter/material.dart';

//Função principal que é o ponto de entrada do aplicativo Flutter
void main() {
  runApp(MyApp()); //Inicializa o aplicativo Flutter com o widget MyApp
}

//Classe principal do aplicativo que herda de StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration App', //Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, //Define a cor primária do tema como azul
      ),
      home: RegistrationPage(), //Define a tela inicial como RegistrationPage
    );
  }
}

//Classe RegistrationPage que é um StatefulWidget para a página de registro de usuário
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

//Estado correspondente à página de registro de usuário
class _RegistrationPageState extends State<RegistrationPage> {
  //Controladores para campos de nome, email e senha
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Valor inicial do dropdown
  String dropdownValue = 'Administrador';
  String greeting = '';

  //Função chamada quando o botão de registro é pressionado
  void _registerUser() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    //Valida os campos de entrada
    if (_validateInputs()) {
      //Exibe um SnackBar indicando que o registro foi bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
        ),
      );
    }
  }

  //Função para validar os campos de entrada
  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      //Se algum campo estiver vazio, exibe um SnackBar indicando que todos os campos devem ser preenchidos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return false; //Retorna falso indicando que a validação falhou
    }
    return true; //Retorna verdadeiro indicando que a validação foi bem-sucedida
  }

  //Método build para construir a interface do usuário
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Define o fundo da tela como uma imagem
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gradients.jpg'), // Carrega uma imagem do arquivo assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Espaçamento
                  SizedBox(height: 120),
                  //Imagem do logo
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'), // Carrega uma imagem do arquivo assets
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 50), //Espaçamento
                  //Campo de entrada para nome
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Nome'),
                    ),
                  ),
                  SizedBox(height: 10), //Espaçamento
                  //Campo de entrada para email
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'E-Mail'),
                    ),
                  ),
                  SizedBox(height: 10), //Espaçamento
                  //Campo de entrada para senha temporária
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true, //Máscara para esconder o texto da senha
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Senha Temporária'),
                    ),
                  ),
                  SizedBox(height: 10), //Espaçamento
                  //Dropdown para selecionar o tipo de usuário
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField(
                      value: dropdownValue,
                      decoration: InputDecoration(border: InputBorder.none),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Administrador', 'Atleta', 'Treinador']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 20)),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20), //Espaçamento
                  //Botão de registro
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _registerUser,
                          child: Text('Cadastrar'), //Texto do botão de registro
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
