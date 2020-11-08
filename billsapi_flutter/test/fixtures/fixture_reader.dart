import 'dart:io';

String fixture(String name) {
  final existsAbsolute = File('./test/fixtures/$name').existsSync();
  if (existsAbsolute) return File('./test/fixtures/$name').readAsStringSync();
  final existsRelative = File('fixtures/$name').existsSync();
  if (existsRelative) {
    return File('fixtures/$name').readAsStringSync();
  } else {
    return File('\\fixtures\\$name').readAsStringSync();
  }
}
