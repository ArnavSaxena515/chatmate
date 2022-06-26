import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import '../widgets/auth_form_widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //initialising firebase instance to be used in this widget
  final _authInstance = FirebaseAuth.instance;

  Future<void> _submitAuthenticationForm({
    required String email,
    required String password,
    required String username,
    required authMode mode,
    required BuildContext ctx,
    XFile? userImageFile,
  }) async {
    try {
      if (mode == authMode.SIGNUP) {
        // create a new user
        final authResult = await _authInstance.createUserWithEmailAndPassword(email: email, password: password);

        // uploading user image to firebase storage

        // creating a path in our firebase storage bucket
        final userImageStorageReference = FirebaseStorage.instance.ref().child("user_image").child(authResult.user!.uid + ".jpg");

        //convert XFile to File type for firebase upload
        File imageToFile = File(userImageFile!.path);

        final imageUploadDetails = await userImageStorageReference.putFile(imageToFile);

        // Store new user's username and email ID
        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'username': username,
          'email': email,
          'userImageUrl': await userImageStorageReference.getDownloadURL(), // get the url to the resource that the reference is pointing to
          // storing user's image url in the collection to retrieve later on.
        });
      }

      if (mode == authMode.LOGIN) {
        // sign in an existing user
        print("sending request");
        // final emailId = await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: username).get().then((value) {
        //   return value.docs[0]['email'];
        // });
        //print(emailId.docs);
        //print(emailId);
        await _authInstance.signInWithEmailAndPassword(email: email, password: password);
      }
    } on PlatformException catch (error) {
      // handle error
      String? message = "An error occurred, please check your credentials";
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.all(5),
        elevation: 3,
        content: Text(
          error.message ?? message,
        ),
      ));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: AuthForm(
            submitMethod: _submitAuthenticationForm,
          ),
        ),
      ),
    );
  }
}
