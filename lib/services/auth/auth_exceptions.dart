//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailAuthExeption implements Exception {}

//generic exceptions
class GenericAuthExeption implements Exception {}

class UserNotLoggedInAuthExeption implements Exception {}
