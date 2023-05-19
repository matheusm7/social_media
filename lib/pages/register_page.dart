import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // sign user up
  void registrar() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      // pop loading circle
      Navigator.pop(context);
      // show error to user
      displayMessage("Senhas não estão iguais");
      return;
    }

    // try creating the user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // pop loading circle
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // welcome back
                  Text("Crie agora sua conta", style: TextStyle(color: Colors.grey[700], fontSize: 22)),
                  const SizedBox(height: 25),

                  // email textfield
                  MytextField(
                    controller: emailTextController,
                    hintText: 'E-mail',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MytextField(
                    controller: passwordTextController,
                    hintText: 'Senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // confirm password textfield
                  MytextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirme a sua Senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: registrar,
                    text: 'Registre-se',
                  ),

                  const SizedBox(height: 25),
                  // go to register page

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Já tem uma conta?', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Faça o login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
