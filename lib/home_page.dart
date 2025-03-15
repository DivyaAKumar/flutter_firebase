import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_new_task.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/date_selector.dart';
import 'package:frontend/widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection("tasks").doc().get();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTask(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            StreamBuilder(
               stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
               // stream: FirebaseFirestore.instance.collection("tasks").where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),---to get only particular task created by current user
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(!snapshot.hasData){
                  return const Text("No data here");

                }
                //future(non real time(futurebuilder) ) to real time(stream)
                return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TaskCard(
                            color: Color(int.parse(snapshot.data!.docs[index].data()['color'].toString().replaceAll("#", ""), radix: 16)).withOpacity(1.0),
                            headerText: snapshot.data!.docs[index].data()['title'],
                            descriptionText: snapshot.data!.docs[index].data()['description'],
                            scheduledDate: snapshot.data!.docs[index].data()['date'].toString(),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: strengthenColor(
                              const Color.fromRGBO(246, 222, 194, 1),
                              0.69,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            '10:00AM',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}
