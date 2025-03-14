import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //make sure flutter framework is properly initialized 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(
        fontFamily: 'Cera Pro',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: 
      //FirebaseAuth.instance.currentUser != null ? const MyHomePage(): const SignUpPage(),

      StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), //for real time update
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
         if (snapshot.data != null ) {
           return const MyHomePage();
         }
          return const SignUpPage();
        }
      )

      // StreamBuilder(
      //   stream: FirebaseAuth.instance.idTokenChanges(), //when id token is refreshed (for secure services,update,sign in-sign out)
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState==ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //    if (snapshot.data != null ) {
      //      return const MyHomePage();
      //    }
      //     return const SignUpPage();
      //   }
      // )

      // StreamBuilder(
      //   stream: FirebaseAuth.instance.userChanges(), //changes when 1) change in user properties-2)user sign in or sign out 3) change in email, passwords, name (id token change)
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState==ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //    if (snapshot.data != null ) {
      //      return const MyHomePage();
      //    }
      //     return const SignUpPage();
      //   }
      // )


      
    );
  }
}
