import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/button.dart';
import 'package:social_media_app/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user in
  void entrar() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // display error message
      displayMessage(e.code);
      //
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
      body: SafeArea(
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
                Text("Bem-vindo de volta!", style: TextStyle(color: Colors.grey[700], fontSize: 22)),
                const SizedBox(height: 25),
                // email textfield
                MytextField(
                  controller: emailTextController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                MytextField(
                  controller: passwordTextController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                // sign in button
                MyButton(
                  onTap: entrar,
                  text: 'Entrar',
                ),
                const SizedBox(height: 25),
                // go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não é um membro?', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Registre-se',
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
    );
  }
}
