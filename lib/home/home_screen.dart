import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/auth/auth_cubit/auth_cubit.dart';
import 'package:map_exam/home/note_display_cubit/note_display_cubit.dart';
import 'package:map_exam/home/note_list_cubit/note_list_cubit.dart';
import 'package:map_exam/home/note_tool_cubit/note_tool_cubit.dart';

class HomeScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteListCubit>().state.notes;
    final showState = context.watch<NoteDisplayCubit>().state;
    final noteTool = context.watch<NoteToolCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: Text(
              '${notes.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notes.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.blueGrey,
        ),
        itemBuilder: (context, index) => ListTile(
          trailing: noteTool ==
                  NoteToolState(
                    noteToolStatus: NoteToolStatus.show,
                    id: notes[index].id,
                  )
              ? SizedBox(
                  width: 110.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          context
                              .read<NoteListCubit>()
                              .deleteNote(notes[index].id);
                        },
                      ),
                    ],
                  ),
                )
              : null,
          title: Text(notes[index].title ?? ''),
          subtitle: showState == NoteDisplayState.show
              ? Text(notes[index].content ?? 'Note content')
              : null,
          onTap: () {},
          onLongPress: () {
            context.read<NoteToolCubit>().toggleNoteTool(notes[index].id);
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: showState == NoteDisplayState.show
                  ? const Icon(Icons.unfold_less)
                  : const Icon(Icons.menu),
              tooltip: 'Show less. Hide notes content',
              onPressed: () {
                context.read<NoteDisplayCubit>().toggleDisplay();
              }),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {
              context.read<AuthCubit>().authRepository.signOut();
            },
          ),
        ],
      ),
    );
  }
}
