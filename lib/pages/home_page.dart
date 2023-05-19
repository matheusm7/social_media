import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/text_field.dart';
import 'package:social_media_app/components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// user
final currentUser = FirebaseAuth.instance.currentUser!;

// text controller
final textController = TextEditingController();

// sign user out
void sair() {
  FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('The wall'),
        actions: const [IconButton(onPressed: sair, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Column(
          children: [
            // the wall
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("User posts").orderBy("TimeStamp", descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // get the message
                      final post = snapshot.data!.docs[index];
                      return WallPost(
                        message: post['Message'],
                        user: post['UserEmail'],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            // post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MytextField(
                      controller: textController,
                      hintText: 'Digite alguma coisa',
                      obscureText: false,
                    ),
                  ),

                  // post button
                  IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            // logged in as
            Text(
              "Logado como:${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
