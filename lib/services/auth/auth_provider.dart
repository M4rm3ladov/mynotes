import 'package:mynotes/services/auth/auth_user.dart';

/// [AuthProvider] abstract class creates a signature/template of methods required for providers.
/// To be implemented by a class provider. Inherited by [FirebaseAuthProvider] and [AuthServiceProvider]
///
/// ex: FirebaseAuth
abstract class AuthProvider {
  /// Initialization method for provider
  Future<void> initialize();

  /// Getter method for taking user
  AuthUser? get currentUser;

  /// Login method for provider requires email and password as named arguments
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  /// Creating user method for provider requires email and password as named arguments
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  /// Logout method for provider
  Future<void> logout();

  /// Email verification method
  Future<void> sendEmailVerification();
}
