class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Tidak ada koneksi internet. Silakan periksa koneksi Anda dan coba lagi.']);

  @override
  String toString() => message;
}
