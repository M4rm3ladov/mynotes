import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

/// [AuthService] is the class that is exposed to the Widgets(UI) for separation of concerns.
/// It implements the [AuthProvider] class and delegates the [FirebaseAuthProvider] methods.
class AuthService implements AuthProvider {
  /// This [AuthProvider] member variable will take in instance of [FirebaseAuthProvider] class.
  final AuthProvider provider;

  /// Generative constructor creates new instance
  //const AuthService(this.provider);

  /// Factory constructor that gets the cached instance or creates new instance of [AuthService] class.
  /// It takes [FirebaseAuthProvider] instance as provider argument.
  //factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  static final AuthService _shared =
      AuthService._sharedInstace(FirebaseAuthProvider());

  /// Named constructor to store callback function that adds [_notes] to [_notesStreamController]
  AuthService._sharedInstace(this.provider);

  /// Factory constructor that returns a static final instance.
  factory AuthService.firebase() => _shared;

  /// Defines the initialization of [Firebase] with optional argument of the currentPlatform.
  @override
  Future<void> initialize() => provider.initialize();

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
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  /// If the user exists return [AuthUser] factory instance with **[Firebase] user** as argument
  /// else return **null**.
  @override
  AuthUser? get currentUser => provider.currentUser;

  /// Defines async Future method of Firebase user taking in [email] and [password] as required named arguments.
  ///
  /// **Try Block:**
  /// - Awaits the authentication of user with [email] and [password]
  /// - Get [currentUser] which the method could return **[Firebase] user** or **[UserNotFoundException]** if null
  /// **Cath Block: catch all [FirebaseAuthException]**
  /// - [UserNotFoundException], [WrongPasswordException], and [GenericAuthException]
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  /// Check if [Firebase] user exists then await [Firebase.signOut] else throw[UserNotFoundException].
  @override
  Future<void> logout() => provider.logout();

  /// Check if [Firebase] user exists then await [Firebase.sendEmailVerification] else throw[UserNotLoggedInAuthException]
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
