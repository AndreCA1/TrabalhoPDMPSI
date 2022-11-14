import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerenciadortarefas/modules/cadastro/pages/cadastro_Page.dart';
import 'package:gerenciadortarefas/modules/login/controllers/login_Controllers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            "Acesse sua conta",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          )),
          toolbarHeight: 105,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  "E-mail:",
                  style: TextStyle(
                      color: Colors.black.withOpacity(
                        0.5,
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-mail não informado';
                    } else if (_controller.validarEmail(value) != true) {
                      return ("E-mail inválido");
                    } else {
                      return null;
                    }
                  },
                  controller: _controller.email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  "Senha:",
                  style: TextStyle(
                      color: Colors.black.withOpacity(
                        0.5,
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                child: TextFormField(
                  obscureText: obscure,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      icon: Icon(
                        obscure == true
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Senha não informada';
                    } else {
                      return null;
                    }
                  },
                  controller: _controller.senha,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _controller.login(_controller.email.text,
                            _controller.senha.text, context);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CadastroPage()));
                  },
                  child: Text(
                    "Cadastre-se",
                    style: TextStyle(
                        color: Colors.black.withOpacity(
                          0.5,
                        ),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ));
  }
}
