import 'package:chatmate/screens/auth_screen.dart';
import 'package:chatmate/utilities/custom_route_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.pink),
          backgroundColor: Colors.pink,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomRouteBuilder(),
            TargetPlatform.iOS: CustomRouteBuilder(),
            TargetPlatform.windows: CustomRouteBuilder(),
          }),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
            secondary: Colors.deepPurple,
            //  brightness: Brightness.dark,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const ChatScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
      routes: {
        ChatScreen.routeName: (_) => const ChatScreen(),
      },
    );
  }
}
