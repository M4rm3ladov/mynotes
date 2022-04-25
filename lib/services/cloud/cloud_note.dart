import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

/// Class for retreiving [CloudNote.fromSnapshot(snapshot)] and
/// creating new instance [CloudNote].
@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final Timestamp dateTimeModified;

  /// Generative Constructor for [CloudNote] class
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.dateTimeModified,
  });

  /// Named constructor initializer for [CloudNote]. Assigns QueryDocumentSnapshot<Map<String, dynamic>>.
  /// For retrieving data from Cloud Firestore.
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        dateTimeModified =
            snapshot.data()[dateTimeModifiedFieldName] as Timestamp;
}
