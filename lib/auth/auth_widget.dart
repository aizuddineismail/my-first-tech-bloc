import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/auth/auth_cubit/auth_cubit.dart';
import 'package:map_exam/home/home_screen.dart';
import 'package:map_exam/home/note_list_cubit/note_list_cubit.dart';
import 'package:map_exam/login/login_screen.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthCubit>().authRepository.user,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          context.read<NoteListCubit>().getAllNotes();
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      }),
    );
  }
}
