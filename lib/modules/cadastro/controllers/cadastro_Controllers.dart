import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// FirebaseFirestore db = FirebaseFirestore.instance;
class CadastroControllers {
  final email = TextEditingController();
  final senha = TextEditingController();
  final nome = TextEditingController();

  cadastro(String email, String senha, context) async {
    bool senhaeEmailvalido = false;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      senhaeEmailvalido = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Senha fraca"), backgroundColor: Colors.redAccent));
        senhaeEmailvalido = false;
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email já está em uso"),
            backgroundColor: Colors.redAccent));
        senhaeEmailvalido = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Preencha todos os campos corretamente!"),
            backgroundColor: Colors.redAccent));
        senhaeEmailvalido = false;
      }
    } catch (e) {
      senhaeEmailvalido = false;
    }
    return senhaeEmailvalido;
  }
}
