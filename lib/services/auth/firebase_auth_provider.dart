import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';

/// Expose only the [FirebaseAuth] and [FirebaseAuthException] class from the api
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

/// [FirebaseAuthProvider] is the class that holds the logic for contacting with [Firebase].
/// It implements the AuthProvider abstract class.
class FirebaseAuthProvider implements AuthProvider {
  /// Defines the initialization of [Firebase] with optional argument of the currentPlatform.
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  /// Defines async Future method of Firebase user taking in [email] and [password] as required named arguments.
  ///
  /// **Try Block:**
  /// - Awaits the creation of user with [email] and [password]
  /// - Get [currentUser] which the method could return **[Firebase] user** or **[UserNotFoundException]** if null
  /// **Cath Block: catch all [FirebaseAuthException]**
  /// - [WeakPasswordException], [InvalidEmailException], and [GenericAuthException]
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthExeption();
      } else {
        throw GenericAuthExeption();
      }
    } catch (_) {
      throw GenericAuthExeption();
    }
  }

  /// If the user exists return [AuthUser] factory instance with **[Firebase] user** as argument
  /// else return **null**.
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  /// Defines async Future method of Firebase user taking in [email] and [password] as required named arguments.
  ///
  /// **Try Block:**
  /// - Awaits the authentication of user with [email] and [password]
  /// - Get [currentUser] which the method could return **[Firebase] user** or [UserNotFoundException] if null
  /// **Cath Block: catch all [FirebaseAuthException]**
  /// - [UserNotFoundException], [WrongPasswordException], and [GenericAuthException]
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthExeption();
      }
    } catch (_) {
      throw GenericAuthExeption();
    }
  }

  /// Check if [Firebase] user exists then await [Firebase.signOut] else throw[UserNotFoundException]
  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFoundAuthException();
    }
  }

  /// Check if [Firebase] user exists then await [Firebase.sendEmailVerification] else throw[UserNotLoggedInAuthException]
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthExeption();
    }
  }
}
