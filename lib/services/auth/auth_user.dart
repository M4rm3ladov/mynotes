/// Expose only the User class from the api
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

/// [AuthUser] is used for separation of concern
@immutable
class AuthUser {
  /// properties
  final String id;
  final String email;
  final bool isEmailVerified;

  /// generative constructor for creating new instance of a user with email and password
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  static final Map<String, AuthUser> _cache = <String, AuthUser>{};

  /// A named factory constructor that creates new or takes a cached instance of User
  /// takes in a User as an argument
  ///
  /// Used in [AuthUser? get currentUser] signature
  factory AuthUser.fromFirebase(User user) {
    return _cache.putIfAbsent(
      user.uid,
      () => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      ),
    );
  }
  // factory AuthUser.fromFirebase(User user) => AuthUser(
  //       id: user.uid,
  //       email: user.email!,
  //       isEmailVerified: user.emailVerified,
  //     );

}
