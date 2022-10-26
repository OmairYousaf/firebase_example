import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/signin.dart';
import 'package:flutter/material.dart';

class SignUpVU extends StatefulWidget {
  const SignUpVU({super.key, required this.title});

  final String title;

  @override
  State<SignUpVU> createState() => _SignUpVUState();
}

class _SignUpVUState extends State<SignUpVU> {
  bool isTrue = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> _createAccount(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Added successfully...');
      return 'User Added successfully...';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password  is too weak...');
        return 'Password  is too weak...';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists...');
        return 'Account already exists..';
      }
      return '';
    }
  }

  void _signIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'ali@gmail.com',
        password: '123456',
      );
      if (FirebaseAuth.instance.currentUser != null) {
        // wrong call in wrong place!
        print('Sign in successfully...');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Firebase Example')),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Sign Up'),
                    onPressed: () async {
                      setState(() {
                        isTrue = true;
                      });
                      String email = nameController.text;
                      String pass = passwordController.text;
                      String result = await _createAccount(email, pass);
                      setState(() {
                        isTrue = false;
                      });
                      showSnackBar(result);
                    },
                  )),
              isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //signup screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInVU()));
                    },
                  )
                ],
              ),
            ],
          )),
    );
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
