import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:map_exam/db/db.dart';

class NoteRepository {
  final FirebaseFirestore firebaseFirestore;

  NoteRepository({
    required this.firebaseFirestore,
  });

  Future<List<Note>> getAllNotes(String email) async {
    try {
      final notesRef = await firebaseFirestore.collection('users').get();

      if (notesRef.docs.isNotEmpty) {
        return notesRef.docs
            .map((doc) => Note.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
      }
      throw 'Note not found';
    } on FirebaseException catch (e) {
      print(e);
      throw 'Firebase Error';
    }
  }
}
