// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mynotes/extensions/list/filter.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;
// import 'crud_exceptions.dart';

// class NotesService {
//   Database? _db;
//   DatabaseUser? _user;
//   List<DatabaseNote> _notes = [];

//   /// [StreamController] of type List<DatabaseNote> for widgets
//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   /// Getter
//   Stream<List<DatabaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotesException();
//         }
//       });
//   // Singleton pattern ensure only one instance throughtout.
//   /// Invokes [NotesService._sharedInstace()] Named constructor instance.
//   static final NotesService _shared = NotesService._sharedInstace();

//   /// Named constructor to store callback function that adds [_notes] to [_notesStreamController]
//   NotesService._sharedInstace() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }

//   /// Factory constructor that returns a static final instance.
//   factory NotesService() => _shared;

//   // #region Notes DB
//   /// Await [getAllNotes] to return [allNotes] <Iterable<DatabaseNote>>.
//   ///
//   /// Store [allNotes] to [_notes] list and [_notes] to [_notesStreamController].
//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await [getUser] to return to [DatabaseUser] [dbUser] and check if NOT equal to [owner]
//   /// throw [CouldNotFindUserException].
//   ///
//   /// Await [getNote] with [note.id] to check if note exists.
//   ///
//   /// Await [update] query of [db] with [noteTable], valued [text] and [isSyncedWithCloud] 0,
//   /// and [note.id] as arguments.To return (int) [updatesCount] affected rows.
//   ///
//   /// Check if [updatesCount] is 0 and throw [CouldNotUpdateNoteException] else
//   ///
//   /// Await on [getNote] to get [DatabaseNote][updatedNote]
//   /// Add [note] to [_notes] and [_notes] to [_notesStreamController] and return [updatedNote].
//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     //make sure note exists
//     await getNote(id: note.id);
//     //update DB
//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//         dateTimeModifiedColumn: DateTime.now().toString(),
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       //_notes[_notes.indexWhere((note) => note.id == updatedNote.id)] =
//       //  _notes[0];
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.insert(0, updatedNote);
//       //_notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await [getUser] to return to [DatabaseUser] [dbUser] and check if NOT equal to [owner]
//   /// throw [CouldNotFindUserException].
//   ///
//   /// Await [insert] query of [db] with [noteTable] as argument,
//   /// to return List<Map<String, Object?>>.
//   ///
//   /// Return <Iterable<DatabaseNote>>
//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       orderBy: dateTimeModifiedColumn + ' DESC',
//     );
//     notes.map((noteRow) => print(DatabaseNote.fromRow(noteRow))).toList();
//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await [getUser] to return to [DatabaseUser] [dbUser] and check if NOT equal to [owner]
//   /// throw [CouldNotFindUserException].
//   ///
//   /// Await query of [db] with [noteTable], 1, [id], as arguments,
//   /// to return List<Map<String, Object?>> [notes].
//   ///
//   /// Check if [notes] is empty and throw [CouldNotFindNoteException] else
//   /// Store instance of [DatabaseNote] to [note].
//   ///
//   /// Remove [note] from [_notes] with [id] and add the [note] instance to prevent duplication.
//   ///
//   /// Add [note] to [_notes] and [_notes] to [_notesStreamController] and return [note].
//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       final indexOfNote = _notes.indexWhere((note) => note.id == id);
//       _notes[indexOfNote] = note;
//       //_notes.removeWhere((note) => note.id == id);
//       //_notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await [getUser] to return to [DatabaseUser] [dbUser] and check if NOT equal to [owner]
//   /// throw [CouldNotFindUserException].
//   ///
//   /// Await [insert] query of [db] with [noteTable], [owner.id], [text], and 1 (true) as arguments,
//   /// to return (int) [noteId] last inserted id.
//   ///
//   /// Store instance of [DatabaseNote] to [note] with [noteId], [owner.id], [text], and, true as arguments.
//   ///
//   /// Add [note] to [_notes] and [_notes] to [_notesStreamController] and return [note].
//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     //make sure owner exists in db with correct id
//     if (dbUser != owner) {
//       throw CouldNotFindUserException();
//     }

//     const text = '';
//     //create the note
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//       dateTimeModifiedColumn: DateTime.now().toString(),
//     });
//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//       dateTimeModified: DateTime.now().toString(),
//     );
//     _notes.insert(0, note);
//     //_notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await query of [db] with [noteTable] as argument,
//   /// await delete query tha returns (int) [deletedCount].
//   ///
//   /// Checks if [deletedCount] is 0 throw [CouldNotDeleteException],
//   /// else Remove items in [_notes] list with [id] and add it to [_notesStreamController]
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     //make sure owner exists in db with correct id
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await query of [db] with [noteTable] as argument,
//   /// returns int rows [numberOfDeletions].
//   ///
//   /// Reset [_notes] to empty list and add it to [_notesStreamController]
//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }
//   // #endregion

//   // #region User DB

//   /// ***Try block:***
//   /// - Get user [getUser] if [email] exists in db, else on [CouldNotFindUserException] return [createUser]
//   /// and store [DatabaseUser] instance in [_user].
//   /// ***Catch block:***
//   /// - rethrow
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) _user = user;
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) _user = createdUser;
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await query of [db] with [userTable], 1 as row count, and [email] as arguments,
//   /// returns List<Map<String, Obj?>> rows(can state columns to return).
//   ///
//   /// If [results] is NOT empty then throw[UserAlreadyExistsException]
//   /// else await [insert] query with [userTable], and [email] and return [userId](last inserted id).
//   ///
//   /// Return instance of [DatabaseUser] with [userId], [email] as arguments.
//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) throw UserAlreadyExistsException();
//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(id: userId, email: email);
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await query of [db] with [userTable], 1 as row count, and [email] as arguments,
//   /// returns List<Map<String, Obj?>> rows(can state columns to return).
//   ///
//   /// If [results] is empty then throw[CouldNotFindUserException]
//   /// else return instance of [DatabaseUser] with first element of [results] as argument.
//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindUserException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   /// Await [_ensureDbIsOpen], if open return [_db] and store to [db] else throw exception.
//   ///
//   /// Await deletion of [db] with [userTable] and [email] as arguments,
//   /// returns row count deleted [deleteCount](int).
//   ///
//   /// If [deleteCount] is not 1 then throw[CouldNotDeleteException].
//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final deleteCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (deleteCount != 1) {
//       throw CouldNotDeleteException();
//     }
//   }

//   // #endregion

//   // #region Open or Close DB

//   /// Check if [db] is not null and return [db] else throw [DatabaseIsNotOpenException].
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) throw DatabaseIsNotOpenException();
//     return db;
//   }

//   /// Invoke [open] or throw [DatabaseAlreadyOpenException].
//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {}
//   }

//   /// Ensure [_db] is not null else throw [DatabaseAlreadyOpenException].
//   ///
//   /// ***Try Block:***
//   /// - Await app directory and join path with [dbName].
//   /// - Await [openDatabase] with [dbPath] and store to [_db] and local var [db].
//   /// - Await excecution [execute] query of [createUserTable] and [createNoteTable] if tables non existent.
//   /// - Await invoke [_cacheNotes] to cache notes to [_notes] and [_notesStreamController]
//   /// ***Catch:***
//   /// - [MissingPlatformDirectoryException] throw [UnableToGetDocumentDirectoryException]
//   Future<void> open() async {
//     if (_db != null) throw DatabaseAlreadyOpenException();
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       print('db loc: ' + dbPath);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       //create user table
//       await db.execute(createUserTable);
//       //create note table
//       await db.execute(createNoteTable);

//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectoryException();
//     }
//   }

//   /// Store [_db] private property to local [db] var and throw [DatabaseIsNotOpenException] if null.
//   /// Else await [close] and assingn [_db] null.
//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }
//   // #endregion
// }

// /// Immutable [DatabaseUser] class for local sqlite storage.
// /// An app user.
// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   /// Generative constructor of [DatabaseUser]
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   /// Named Initializer constructor that takes a Map<String, Object> as arguments,
//   /// then initializing those in [id] and [email] properties.
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   /// Override [toString()] method to show [id] and [email] of instantiated user.
//   @override
//   String toString() => 'Person, id = $id, email = $email';

//   /// Override [operator ==] method to compare DatabaseUser objects.
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// /// [DatabaseNote] class for creating notes
// @immutable
// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;
//   final String dateTimeModified;

//   /// Generative Constructor for [DatabaseNote] class. Creation of new note.
//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//     required this.dateTimeModified,
//   });

//   /// Named constructor initializer for [DatabaseNote]. Assigns Map<String, Object>
//   /// to [id], [userId], [text], [isSyncedWithCloud] properties.
//   ///
//   /// For Retreiving data from Sqlite.
//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false,
//         dateTimeModified = map[dateTimeModifiedColumn] as String;

//   /// Override [toString()] method to show [id], [userId], [isSyncedWithCloud], and [text] of instantiated note.
//   @override
//   String toString() =>
//       'Note, id = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text, dateTimeModified = $dateTimeModified';

//   /// Override [operator ==] method to compare DatabaseUser objects.
//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// /// Defiinition of constants to be used in [NotesService] class
// const dbName = 'noted.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const dateTimeModifiedColumn = 'date_time_modified';
// const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	TEXT,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         "date_time_modified"	TEXT NOT NULL,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );
//       ''';
