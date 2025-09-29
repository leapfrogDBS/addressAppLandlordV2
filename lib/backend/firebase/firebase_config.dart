import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCK8ZZAvE5Scc9dab6z9o4d7K2M24cWmPs",
            authDomain: "addressedapp.firebaseapp.com",
            projectId: "addressedapp",
            storageBucket: "addressedapp.firebasestorage.app",
            messagingSenderId: "193876818360",
            appId: "1:193876818360:web:18cabfab141e98148e374d"));
  } else {
    await Firebase.initializeApp();
  }
}
