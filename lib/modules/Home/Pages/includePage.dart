import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncludePage extends StatefulWidget {
  final bool alterar;
  final String? tarefa;
  final String? docid;
  const IncludePage({required this.alterar, this.tarefa, this.docid, super.key});

  @override
  State<IncludePage> createState() => _IncludePageState();
}

class _IncludePageState extends State<IncludePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tarefa = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(widget.tarefa == null){

    }
    else{
      tarefa.text = widget.tarefa!;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: 
        widget.alterar == false ? const Text(
          "Criação de tarefas",
          style: TextStyle(fontSize: 30),
        )
        :
        const Text(
          "Alteraração de tarefas",
          style: TextStyle(fontSize: 30),
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(250),
                  ],
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: "Digite aqui sua tarefa... limite de 250 caracteres",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira uma tarefa';
                    } else {
                      return null;
                    }
                  },
                  controller: tarefa,
                  keyboardType: TextInputType.text),
            ),
            const SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if(widget.alterar == false){
                      await FirebaseFirestore.instance
                          .collection("Tarefas")
                          .doc()
                          .set({"tarefa": tarefa.text, "data": DateTime.now()});
                          
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Tarefa salva com sucesso!"),
                                backgroundColor: Colors.green));
                      }
                      }
                      else{
                         await FirebaseFirestore.instance
                          .collection("Tarefas")
                          .doc(widget.docid)
                          .update({"tarefa": tarefa.text});
                          
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Tarefa alterada com sucesso!"),
                                backgroundColor: Colors.green));
                      }
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Salvar',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
