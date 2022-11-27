import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadortarefas/modules/Home/Pages/includePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshots = FirebaseFirestore.instance
      .collection("Tarefas")
      .orderBy("data", descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: null,
        title: const Center(
            child: Text(
          "Visualização de tarefas",
          style: TextStyle(fontSize: 30),
        )),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.width - 10,
        child: StreamBuilder(
            stream: snapshots,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.amber,
                  ),
                );
              }
              return (snapshot.data!.docs.isNotEmpty)
                  ? ListView(
                      children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  border: Border.all(
                                      width: 3,
                                      color: Colors.black.withOpacity(0.5))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 110,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(document
                                            .data()["tarefa"]
                                            .toString()),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                             IncludePage(alterar: true, tarefa: document
                                            .data()["tarefa"]
                                            .toString(), docid:document.reference.id.toString(),), ),
                                                  );
                                                },
                                                child: const Text("Alterar"))),
                                        Expanded(
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Tarefas")
                                                      .doc(
                                                          document.reference.id)
                                                      .delete();
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Essa tarefa foi deletada."),
                                                                backgroundColor:
                                                                    Colors
                                                                        .red));
                                                  }
                                                },
                                                child: const Text("Deletar"))),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }).toList())
                  : const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "Não há tarefas não cadastradas.",
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
            }),
      ),
      bottomSheet: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncludePage(alterar: false,)),
                );
              },
              label: const Text("Criar uma nova tarefa"),
            ),
          ))),
    );
  }
}
