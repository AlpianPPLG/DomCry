class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = 'Kredensial tidak valid. Silakan periksa kembali email dan password Anda.']);

  @override
  String toString() => message;
}
