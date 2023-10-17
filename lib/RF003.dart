//Importando pacotes necessários
import 'dart:math';
import 'package:flutter/material.dart';

//Função principal que inicializa o aplicativo Flutter
void main() {
  runApp(AthleteRegistrationScreen());
}

//Classe para a tela de registro do atleta, que é um StatefulWidget
class AthleteRegistrationScreen extends StatefulWidget {
  @override
  _AthleteRegistrationScreenState createState() =>
      _AthleteRegistrationScreenState();
}

//Estado correspondente à tela de registro do atleta
class _AthleteRegistrationScreenState extends State<AthleteRegistrationScreen> {
  //Chave global para o formulário, permite a validação do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controladores para os campos de entrada
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController originClubController = TextEditingController();
  final TextEditingController workplaceController = TextEditingController();
  final TextEditingController medicalInsuranceController =
      TextEditingController();
  final TextEditingController medicationAllergiesController =
      TextEditingController();
  final TextEditingController stylesController = TextEditingController();
  final TextEditingController testsController = TextEditingController();

  //Método chamado quando o widget é inicializado
  @override
  void initState() {
    super.initState();
    generateRandomID(); //Gera um ID aleatório quando a tela é inicializada
  }

  //Método para gerar um ID aleatório
  void generateRandomID() {
    final random = Random();
    int id = random.nextInt(9000) + 1000;
    idController.text = id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          //Barra de AppBar na parte superior da tela
          title: Text('Registro de Atletas'),
          backgroundColor:
              Color.fromARGB(255, 3, 5, 56), //Cor de fundo da AppBar
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png', //Exibe o logotipo na AppBar
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
        body: Form(
          //Formulário para a entrada de dados do atleta
          key: _formKey, //Chave global para o formulário
          autovalidateMode: AutovalidateMode
              .onUserInteraction, //Validação automática quando o usuário interage
          child: ListView(
            //Lista de widgets na tela
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              //Campos de entrada para os detalhes do atleta
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID'),
                enabled: false,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: birthDateController,
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: placeOfBirthController,
                decoration: InputDecoration(labelText: 'Naturalidade'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nationalityController,
                decoration: InputDecoration(labelText: 'Nacionalidade'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: rgController,
                decoration: InputDecoration(labelText: 'RG'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sexController,
                decoration: InputDecoration(labelText: 'Sexo'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Endereço Completo'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: motherNameController,
                decoration: InputDecoration(labelText: "Nome da Mãe"),
              ),
              TextFormField(
                controller: fatherNameController,
                decoration: InputDecoration(labelText: "Nome do Pai"),
              ),
              TextFormField(
                controller: originClubController,
                decoration: InputDecoration(labelText: 'Clube de Origem'),
              ),
              TextFormField(
                controller: workplaceController,
                decoration: InputDecoration(labelText: 'Local de Trabalho'),
              ),
              TextFormField(
                controller: medicalInsuranceController,
                decoration: InputDecoration(labelText: 'Convênio Médico'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: medicationAllergiesController,
                decoration: InputDecoration(
                    labelText: 'Alergia a Medicamentos (quais)?'),
              ),
              TextFormField(
                controller: stylesController,
                decoration: InputDecoration(labelText: 'Estilo(s)'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: testsController,
                decoration: InputDecoration(labelText: 'Prova(s)'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo é obrigatório.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Se o formulário é válido, realiza ações de registro
                  if (_formKey.currentState?.validate() ?? false) {}
                },
                child: Text('Registrar Atleta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
