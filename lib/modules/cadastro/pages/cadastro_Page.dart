import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gerenciadortarefas/modules/cadastro/controllers/cadastro_Controllers.dart';
import 'package:gerenciadortarefas/modules/login/pages/login_Page.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _controllerCadastro = CadastroControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios)),
        toolbarHeight: 105,
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Criação de Conta",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: TextFormField(
              controller: _controllerCadastro.nome,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome',
                hintStyle: TextStyle(color: Colors.purple),
                label: Text("Nome:"),
                prefixIcon: Icon(Icons.person),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: TextFormField(
              controller: _controllerCadastro.email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.purple),
                label: Text("Email:"),
                prefixIcon: Icon(Icons.email),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextFormField(
              controller: _controllerCadastro.senha,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Senha',
                hintStyle: TextStyle(color: Colors.purple),
                label: Text("Senha:"),
                prefixIcon: Icon(Icons.key),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                Map<String, String> dados = Map<String, String>();
                dados["nome"] = _controllerCadastro.nome.text;
                dados["email"] = _controllerCadastro.email.text;

                if (await _controllerCadastro.cadastro(
                    _controllerCadastro.email.text,
                    _controllerCadastro.senha.text,
                    context)) {
                  User? usuario = _firebaseAuth.currentUser;
                  String id;
                  if (usuario != null) {
                    id = usuario.uid;
                    db.collection('Usuarios').doc(id).set(dados);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Usuário cadastrado com sucesso!"),
                        backgroundColor: Colors.greenAccent));
                  }
                }
                ;
              },
              child: const Text("Salvar"),
            ),
          )
        ],
      ),
    );
  }
}
