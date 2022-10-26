import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();
  bool isTrue = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Example'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Main Screen',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: const Center(
                      child: Text('Enter message here to store in firebase'))),
              const SizedBox(
                height: 24,
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Send to Firebase'),
                    onPressed: () async {
                      setState(() {
                        isTrue = true;
                      });
                      print(textController.text);
                      String result = await addUser(textController.text);
                      setState(() {
                        isTrue = false;
                      });
                      showSnackBar(result);
                    },
                  )),
              isTrue
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink()
            ],
          )),
    );
  }

  Future<String> addUser(String msg) async {
    // Call the user's CollectionReference to add a new user
    try {
      users.doc().set({"message": msg});
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  showSnackBar(String label) {
    final snackBar = SnackBar(
      content: Text(label),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
