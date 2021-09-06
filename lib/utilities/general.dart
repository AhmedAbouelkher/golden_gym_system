import 'package:collection/collection.dart';

bool isNumeric(String s) {
  return num.tryParse(s.trim()) != null;
}

String enumToString(Object o) => o.toString().split('.').last;
T? enumFromString<T>(String key, List<T> values) => values.firstWhereOrNull((v) => key == enumToString(v!));
