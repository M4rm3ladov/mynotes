/// Cloud Storage Exception class.
/// Can be instantiated.
class CloudStorageExcetion implements Exception {
  const CloudStorageExcetion();
}

/// Create exception
class CouldNotCreateNoteException extends CloudStorageExcetion {}

/// Read Exception
class CouldNotGetAllNotesException extends CloudStorageExcetion {}

/// Update Exception
class CouldNotUpdateNoteException extends CloudStorageExcetion {}

/// Delete Exception
class CouldNotDeleteNoteException extends CloudStorageExcetion {}
