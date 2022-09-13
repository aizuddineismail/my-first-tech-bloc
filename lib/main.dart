import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/auth/auth_cubit/auth_cubit.dart';
import 'package:map_exam/auth/auth_widget.dart';
import 'package:map_exam/db/repositories/auth_repository.dart';
import 'package:map_exam/firebase_options.dart';

// import 'login_screen.dart';
// import 'home/home_screen.dart';
// import 'edit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  firebaseAuth.useAuthEmulator('10.0.2.2', 9099);

  final firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.useFirestoreEmulator('10.0.2.2', 8080);
  firebaseFirestore.settings = const Settings(
    persistenceEnabled: false,
    sslEnabled: false,
  );
  runApp(App(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  ));
}

class App extends StatelessWidget {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  const App({
    Key? key,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(
        firebaseAuth: firebaseAuth,
        firebaseFirestore: firebaseFirestore,
      ),
      child: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: MaterialApp(
          title: 'myFirst',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AuthWidget(),
          // home: const LoginScreen(),
          // home: const HomeScreen(),
          // home: const EditScreen(),
        ),
      ),
    );
  }
}
