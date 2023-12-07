import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'attachments.dart';

void main() {
  runApp(AthleteRegistrationScreen());
}

class AthleteRegistrationScreen extends StatefulWidget {
  @override
  _AthleteRegistrationScreenState createState() =>
      _AthleteRegistrationScreenState();
}

class _AthleteRegistrationScreenState extends State<AthleteRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, Map<String, String>> athletesData = {};

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerAtleta() async {
    String ID = idController.text;
    String name = nameController.text;
    String birthdate = birthDateController.text;
    String placeofbirth = placeOfBirthController.text;
    String nationality = nationalityController.text;
    String rg = rgController.text;
    String cpf = cpfController.text;
    String sex = sexController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String mothername = motherNameController.text;
    String fathername = fatherNameController.text;
    String originclub = originClubController.text;
    String workplace = workplaceController.text;
    String medicalinsurance = medicalInsuranceController.text;
    String medallallergy = medicationAllergiesController.text;
    String style = stylesController.text;
    String test = testsController.text;

    if (_formKey.currentState?.validate() ?? false) {
      final athleteId = (ID).toString();

      _firestore.collection('atletas').doc(athleteId).set({
        'Nome': name.isEmpty ? '' : name,
        'Data_Nascimento': birthdate.isEmpty ? '' : birthdate,
        'Localidade_Nascimento': placeofbirth.isEmpty ? '' : placeofbirth,
        'Cidadania': nationality.isEmpty ? '' : nationality,
        'RG': rg.isEmpty ? '' : rg,
        'CPF': cpf.isEmpty ? '' : cpf,
        'Sexo': sex.isEmpty ? '' : sex,
        'Endereço': address.isEmpty ? '' : address,
        'Telefone': phone.isEmpty ? '' : phone,
        'Nome_Mae': mothername.isEmpty ? '' : mothername,
        'Nome_Pai': fathername.isEmpty ? '' : fathername,
        'Clube_Origem': originclub.isEmpty ? '' : originclub,
        'Lugar_de_Trabalho': workplace.isEmpty ? '' : workplace,
        'Plano_de_Saúde': medicalinsurance.isEmpty ? '' : medicalinsurance,
        'Alérgenos_Medicais': medallallergy.isEmpty ? '' : medallallergy,
        'Estilos_Praticados': style.isEmpty ? '' : style,
        'Testes_Realizados': test.isEmpty ? '' : test,
      });

      idController.clear();
      nameController.clear();
      birthDateController.clear();
      placeOfBirthController.clear();
      nationalityController.clear();
      rgController.clear();
      cpfController.clear();
      sexController.clear();
      addressController.clear();
      phoneController.clear();
      motherNameController.clear();
      fatherNameController.clear();
      originClubController.clear();
      workplaceController.clear();
      medicalInsuranceController.clear();
      medicationAllergiesController.clear();
      stylesController.clear();
      testsController.clear();

      /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Atleta Registrado'),
            content: Text('As informações do atleta foram salvas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );*/
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registro de Atletas'),
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
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID do Aluno'),
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
                  String ID_Anexos = idController.text;
                  registerAtleta();
                  Navigator.pushNamed(context, '/Attachments', arguments: ID_Anexos);
                },
                child: Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      routes: {
        '/Attachments': (context) => AttachmentScreen(),
      },
    );
  }
}
