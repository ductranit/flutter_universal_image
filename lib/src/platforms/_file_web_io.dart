import 'dart:typed_data';

/// Fake File for Web
class File {
  File(String path) {
    throw UnsupportedError('Not available for web');
  }

  /// Get the path of the file.
  String get path => '';

  /// Reads the entire file contents as a list of bytes.
  ///
  /// Returns a `Future<Uint8List>` that completes with the list of bytes that
  /// is the contents of the file.
  Future<Uint8List> readAsBytes() {
    throw UnsupportedError('Not available for web');
  }

  /// Reads the entire file contents as a list of bytes synchronously.
  Uint8List readAsBytesSync() {
    throw UnsupportedError('Not available for web');
  }
}
