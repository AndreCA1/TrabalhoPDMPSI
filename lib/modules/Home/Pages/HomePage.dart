import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshots = FirebaseFirestore.instance
      .collection("OSs")
      .where("estoquista", isEqualTo: false)
      .orderBy("data", descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Bem vindo"),
      ),
       body: StreamBuilder(
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
            return SizedBox(
                width: 10,
                height: 10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 20, bottom: 10, left: 10),
                        child: Text(
                          "Tarefas",
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        ),
                      ),
                      (snapshot.data!.docs.isNotEmpty)
                          ? SliverGrid.count(
                              crossAxisSpacing: 5,
                              childAspectRatio: (1 / 1.65),
                              crossAxisCount: 2,
                              children: snapshot.data!.docs.map((document) {
                                return SizedBox();
                              }).toList())
                          : const SliverToBoxAdapter(
                              child: Center(
                                  child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 50),
                              child: Text(
                                "Não há tarefas não cadastradas.",
                                style: TextStyle(fontSize: 20),
                              ),
                            ))),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 15,
                        ),
                      )
                    ]));
          }),
    );
  }
}
