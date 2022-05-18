import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  // Singleton pattern ensure only one instance throughtout.
  /// Invokes [FirebaseCloudStorage._sharedInstace()] Named constructor instance.
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstace();

  /// Named constructor to store callback function that adds [_notes] to [_notesStreamController]
  FirebaseCloudStorage._sharedInstace();

  /// Factory constructor that returns a static final instance.
  factory FirebaseCloudStorage() => _shared;

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteEmptyNote() async {
    try {
      await notes
          .where(textFieldName.isEmpty)
          .get()
          .then((value) => value.docs.map((doc) => doc.reference.delete()));
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        dateTimeModifiedFieldName:
            FieldValue.serverTimestamp(), //Timestamp.now(),
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      dateTimeModifiedFieldName:
          FieldValue.serverTimestamp(), //Timestamp.now(),
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
      dateTimeModified:
          fetchedNote.data()![dateTimeModifiedFieldName] ?? Timestamp.now(),
      //dateTimeModified: fetchedNote.data()![dateTimeModifiedFieldName],
    );
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy(dateTimeModifiedFieldName, descending: true)
        .snapshots()
        .where((snap) => !snap.metadata.hasPendingWrites)
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
  }

  Future<Iterable<CloudNote>> getNotes({required ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
