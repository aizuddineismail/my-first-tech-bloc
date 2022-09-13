import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/auth/auth_cubit/auth_cubit.dart';
import 'package:map_exam/auth/auth_widget.dart';
import 'package:map_exam/db/repositories/auth_repository.dart';
import 'package:map_exam/db/repositories/note_repository.dart';
import 'package:map_exam/firebase_options.dart';
import 'package:map_exam/home/note_display_cubit/note_display_cubit.dart';
import 'package:map_exam/home/note_list_cubit/note_list_cubit.dart';
import 'package:map_exam/home/note_tool_cubit/note_tool_cubit.dart';

// import 'login_screen.dart';
// import 'home/home_screen.dart';
// import 'edit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'map-exam',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        RepositoryProvider<NoteRepository>(
          create: (context) =>
              NoteRepository(firebaseFirestore: firebaseFirestore),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<NoteListCubit>(
            create: (context) => NoteListCubit(
                noteRepository: context.read<NoteRepository>(),
                authCubit: context.read<AuthCubit>()),
          ),
          BlocProvider<NoteDisplayCubit>(
            create: (context) => NoteDisplayCubit(),
          ),
          BlocProvider<NoteToolCubit>(
            create: (context) => NoteToolCubit(),
          ),
        ],
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
